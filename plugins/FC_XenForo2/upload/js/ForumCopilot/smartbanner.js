(function (global) {
  'use strict';

  var STORAGE_KEY = 'fc-smartbanner-dismissed-until';

  var defaults = {
    title: 'Forum Copilot',
    subtitle: 'Open in the app',
    cta: 'Open',
    icon: '',
    appStoreId: '',           // e.g. "id6755660616"
    playStoreId: '',          // e.g. "com.forumcopilot.mobile"
    dismissDays: 7,
    position: 'bottom',       // 'bottom' | 'top'
    mountTo: 'body',
    // If something is pinned to the bottom of the viewport (ad anchor, cookie
    // bar, sticky CTA), flip the banner to the top so they don't fight.
    avoidSelectors: [
      '.adsbygoogle-anchor',          // AdSense Anchor / Vignette
      'ins.adsbygoogle[data-anchor-status]',
      '.googlefcPresent',
      '#google_esf',
      '[id^="google_ads_iframe"][style*="position: fixed"]',
      '#onetrust-banner-sdk',         // OneTrust CMP
      '.cc-window',                   // cookieconsent.js
      '.cookie-consent',
      '#cookie-banner',
      '.qc-cmp2-container',           // Quantcast CMP
      '#CybotCookiebotDialog',        // Cookiebot
      '#sp_message_container_*',      // Sourcepoint
    ],
    // Time window after init to keep watching for late-injected bottom bars.
    avoidScanMs: 2500,
  };

  function detectPlatform() {
    var override = (location.search.match(/[?&]platform=(ios|android)/) || [])[1];
    if (override) return override;
    var ua = navigator.userAgent || '';
    if (/iPhone|iPod/.test(ua)) return 'ios';
    if (/iPad/.test(ua) || (/Macintosh/.test(ua) && 'ontouchend' in document)) return 'ios';
    if (/Android/.test(ua)) return 'android';
    return null;
  }

  function isInWebView() {
    var ua = navigator.userAgent || '';
    // Heuristic: app's WebView typically sets a custom UA marker; also Safari standalone.
    if (/ForumCopilot/i.test(ua)) return true;
    if (window.navigator.standalone === true) return true; // iOS PWA / home-screen
    return false;
  }

  function isDismissed() {
    try {
      var until = parseInt(localStorage.getItem(STORAGE_KEY), 10);
      return until && Date.now() < until;
    } catch (e) {
      return false;
    }
  }

  function setDismissed(days) {
    try {
      localStorage.setItem(STORAGE_KEY, String(Date.now() + days * 24 * 60 * 60 * 1000));
    } catch (e) {}
  }

  // Return true if `el` is visible and pinned to the bottom of the viewport,
  // overlapping our banner's horizontal extent enough to matter.
  function blocksBottom(el) {
    if (!el || !el.getBoundingClientRect) return false;
    var cs;
    try { cs = getComputedStyle(el); } catch (e) { return false; }
    if (cs.display === 'none' || cs.visibility === 'hidden' || parseFloat(cs.opacity) === 0) {
      return false;
    }
    if (cs.position !== 'fixed' && cs.position !== 'sticky') return false;
    var rect = el.getBoundingClientRect();
    if (rect.width < 1 || rect.height < 1) return false;
    var vh = window.innerHeight || document.documentElement.clientHeight;
    var vw = window.innerWidth || document.documentElement.clientWidth;
    // Bottom edge of element within ~80px of viewport bottom.
    if (rect.bottom < vh - 80) return false;
    // Must cover a meaningful slice of the width (>50%) — corner chat widgets
    // are narrow and shouldn't trigger a flip.
    if (rect.width < vw * 0.5) return false;
    return true;
  }

  function findBottomConflict(selectors) {
    for (var i = 0; i < selectors.length; i++) {
      var sel = selectors[i];
      var matches;
      try { matches = document.querySelectorAll(sel); }
      catch (e) { continue; }
      for (var j = 0; j < matches.length; j++) {
        if (blocksBottom(matches[j])) return matches[j];
      }
    }
    return null;
  }

  function storeUrl(platform, cfg) {
    if (platform === 'ios' && cfg.appStoreId) {
      return 'https://apps.apple.com/app/' + cfg.appStoreId;
    }
    if (platform === 'android' && cfg.playStoreId) {
      return 'https://play.google.com/store/apps/details?id=' + cfg.playStoreId;
    }
    return '#';
  }

  function buildBanner(cfg, platform) {
    var el = document.createElement('div');
    var posClass = cfg.position === 'top' ? 'fc-smartbanner--top' : 'fc-smartbanner--bottom';
    el.className = 'fc-smartbanner ' + posClass;
    el.setAttribute('role', 'banner');

    var close = document.createElement('button');
    close.className = 'fc-smartbanner__close';
    close.setAttribute('aria-label', 'Dismiss');
    close.textContent = '×';

    var icon = document.createElement('div');
    icon.className = 'fc-smartbanner__icon';
    if (cfg.icon) icon.style.backgroundImage = 'url(' + cfg.icon + ')';

    var body = document.createElement('div');
    body.className = 'fc-smartbanner__body';
    var title = document.createElement('div');
    title.className = 'fc-smartbanner__title';
    title.textContent = cfg.title;
    var subtitle = document.createElement('div');
    subtitle.className = 'fc-smartbanner__subtitle';
    subtitle.textContent = cfg.subtitle;
    body.appendChild(title);
    body.appendChild(subtitle);

    var cta = document.createElement('a');
    cta.className = 'fc-smartbanner__cta';
    cta.textContent = cfg.cta;
    cta.href = storeUrl(platform, cfg);
    cta.rel = 'noopener';

    el.appendChild(close);
    el.appendChild(icon);
    el.appendChild(body);
    el.appendChild(cta);

    return { root: el, close: close, cta: cta };
  }

  function init(userCfg) {
    var cfg = Object.assign({}, defaults, userCfg || {});

    if (isInWebView()) return;
    if (isDismissed()) return;

    var platform = detectPlatform();
    if (!platform) return;

    var mount = typeof cfg.mountTo === 'string'
      ? document.querySelector(cfg.mountTo)
      : cfg.mountTo;
    if (!mount) return;

    // Auto-flip to top if the bottom is occupied (ads, CMP, etc.).
    if (cfg.position === 'bottom' && findBottomConflict(cfg.avoidSelectors)) {
      cfg.position = 'top';
    }

    var state = { position: cfg.position };
    var parts = buildBanner(cfg, platform);
    mount.appendChild(parts.root);

    function applyOffset() {
      document.documentElement.classList.remove('fc-smartbanner-offset-top');
      document.documentElement.classList.remove('fc-smartbanner-offset-bottom');
      document.documentElement.classList.add('fc-smartbanner-offset-' + state.position);
    }

    // Force reflow so the slide-in animation runs.
    void parts.root.offsetWidth;
    parts.root.classList.add('fc-smartbanner--visible');
    applyOffset();

    parts.close.addEventListener('click', function () {
      parts.root.classList.remove('fc-smartbanner--visible');
      document.documentElement.classList.remove('fc-smartbanner-offset-' + state.position);
      setDismissed(cfg.dismissDays);
      setTimeout(function () { parts.root.remove(); }, 250);
    });

    // Late-loading ads: keep scanning briefly. If a bottom conflict appears
    // after we've already shown at the bottom, flip up.
    if (cfg.avoidScanMs > 0) {
      var deadline = Date.now() + cfg.avoidScanMs;
      var poll = setInterval(function () {
        if (Date.now() > deadline || !parts.root.isConnected) {
          clearInterval(poll);
          return;
        }
        if (state.position === 'bottom' && findBottomConflict(cfg.avoidSelectors)) {
          state.position = 'top';
          parts.root.classList.remove('fc-smartbanner--bottom');
          parts.root.classList.add('fc-smartbanner--top');
          applyOffset();
          clearInterval(poll);
        }
      }, 250);
    }
  }

  global.SmartBanner = { init: init, _detectPlatform: detectPlatform };
})(window);
