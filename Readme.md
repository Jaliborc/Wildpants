== Global Events
| Name | Sent by | Used by | Description |
| UPDATE_ALL | Options and 3rd party mods | Multiple components | Update frames and every component |
| FLASH_FIND (itemID) | item | item | Flash every item with the given itemID |
| SEARCH_CHANGED | Search boxes | item | The global search query has been changed. Used only by Bagnon |

== Frame Events
| Name | Sent by | Used by | Description |
| PLAYER_CHANGED | playerDropdown | Multiple components | The player to be displayed has been changed |
| BAG_FRAME_TOGGLED | bagToggle | bagFrame and frame | The bagFrame has been toggled on/off |
| FILTERS_CHANGED | Filtering components | itemFrame | The local frame filter parameters have been changed. Used only by Combuctor |
| ITEM_FRAME_RESIZED | itemFrame | frame | The itemFrame dimentions have changed. Used only by Bagnon |

| BAG_TOGGLED (bagSlot) | bag | itemFrame | The items in the given bag slot have been toggled |
| FOCUS_BAG (bagSlot) | bag | item | The items in the given bag slot should be highlighted |