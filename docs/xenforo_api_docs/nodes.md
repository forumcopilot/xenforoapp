# XenForo API - Nodes

## GET nodes/

Gets the node tree.

### Parameters

None.

### Response

| Output | Type | Description |
|--------|------|-------------|
| tree_map | array | A mapping that connects node parent IDs to a list of their child node IDs |
| nodes | [Node](#type_Node)[] | List of all nodes |

## POST nodes/

Creates a new node

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| node[title] | string | **Required** |
| node[node_name] | string | |
| node[description] | string | |
| node[parent_node_id] | integer | **Required** |
| node[display_order] | integer | |
| node[display_in_list] | bool | |
| type_data | array | Type-specific node data. The available options will vary based on the node type involved. |
| node_type_id | string | **Required** |

### Response

| Output | Type | Description |
|--------|------|-------------|
| node | [Node](#type_Node) | Information about the created node |

## GET nodes/flattened

Gets a flattened node tree. Traversing this will return a list of nodes in the expected order.

### Parameters

None.

### Response

| Output | Type | Description |
|--------|------|-------------|
| nodes_flat | array | An array. Each entry contains keys of "node" and "depth" |

## GET nodes/{id}/

Gets information about the specified node

### Parameters

None.

### Response

| Output | Type | Description |
|--------|------|-------------|
| node | [Node](#type_Node) | |

## POST nodes/{id}/

Updates the specified node

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| node[title] | string | |
| node[node_name] | string | |
| node[description] | string | |
| node[parent_node_id] | integer | |
| node[display_order] | integer | |
| node[display_in_list] | bool | |
| type_data | array | Type-specific node data. The available options will vary based on the node type involved. |

### Response

| Output | Type | Description |
|--------|------|-------------|
| node | [Node](#type_Node) | The updated node information |

## DELETE nodes/{id}/

Deletes the specified node

### Parameters

| Input | Type | Description |
|-------|------|-------------|
| delete_children | bool | If true, child nodes will be deleted. Otherwise, they will be connected to this node's parent. |

### Response

| Output | Type | Description |
|--------|------|-------------|
| success | true | |
