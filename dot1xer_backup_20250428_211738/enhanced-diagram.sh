#!/bin/bash

# PortnoxDiagram - Comprehensive Portnox Cloud NAC Diagramming Tool Integration
# Version: 1.0.0
# Date: April 25, 2025
# Compatible with UaXSupreme - https://github.com/iammrherb/UaXSupreme
# 
# This script integrates a complete diagramming solution for Portnox Cloud NAC
# with comprehensive stencil libraries, vendor icons, and templated workflows
# for all NAC deployment scenarios and best practices.

# Set text colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Display header
echo -e "${BLUE}================================================================${NC}"
echo -e "${BLUE}  Portnox NAC Diagram Integration for UaXSupreme Platform       ${NC}"
echo -e "${BLUE}================================================================${NC}"

# Check if we're in the UaXSupreme root directory
if [ ! -f "index.html" ] || [ ! -d "js" ]; then
    echo -e "${RED}Error: This script must be run from the UaXSupreme root directory.${NC}"
    echo -e "${YELLOW}Please navigate to the directory containing index.html and try again.${NC}"
    exit 1
fi

# Backup important files
echo -e "${YELLOW}Creating backups of important files...${NC}"
TIMESTAMP=$(date +%Y%m%d%H%M%S)
cp index.html "index.html.bak.$TIMESTAMP" || echo -e "${RED}Failed to backup index.html${NC}"
if [ -d js/diagrams ]; then
    cp -r js/diagrams "js/diagrams.bak.$TIMESTAMP" || echo -e "${RED}Failed to backup js/diagrams${NC}"
fi

# Create necessary directory structure
echo -e "${YELLOW}Creating directory structure for NAC diagrams...${NC}"
mkdir -p js/diagrams/src
mkdir -p js/diagrams/stencils
mkdir -p js/diagrams/templates/deployment
mkdir -p js/diagrams/templates/authentication
mkdir -p js/diagrams/templates/segmentation
mkdir -p js/diagrams/templates/industry
mkdir -p js/diagrams/templates/bestpractice
mkdir -p css/diagrams
mkdir -p images/stencils/logos
mkdir -p images/stencils/vendors

# Create vendor-specific directories
VENDORS=("cisco" "aruba" "juniper" "fortinet" "hp" "dell" "extreme" "arista" "paloalto" "checkpoint" "ruckus" "meraki")
for vendor in "${VENDORS[@]}"; do
    mkdir -p "images/stencils/vendors/$vendor"
done

# Create infrastructure component directories
mkdir -p images/stencils/network
mkdir -p images/stencils/devices
mkdir -p images/stencils/authentication
mkdir -p images/stencils/cloud
mkdir -p images/stencils/portnox
mkdir -p images/stencils/certificates
mkdir -p images/stencils/security
mkdir -p images/stencils/users
mkdir -p images/stencils/services

# Download required libraries
echo -e "${YELLOW}Downloading and setting up required libraries...${NC}"

# Function to download file with progress
download_with_progress() {
    local url=$1
    local output=$2
    echo -e "${BLUE}Downloading: $(basename $output)${NC}"
    curl -# -L -o "$output" "$url"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to download: $url${NC}"
        return 1
    fi
    return 0
}

# Download and extract mxGraph (core of draw.io)
download_with_progress "https://github.com/jgraph/mxgraph/archive/v4.2.2.zip" "mxgraph.zip"
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Extracting mxGraph...${NC}"
    unzip -q mxgraph.zip
    cp -r mxgraph-4.2.2/javascript/src/* js/diagrams/src/
    rm -rf mxgraph-4.2.2
    rm mxgraph.zip
else
    echo -e "${RED}Creating minimal mxGraph implementation instead...${NC}"
    # We'll create a minimal implementation if download fails
fi

# Create base diagram libraries
echo -e "${YELLOW}Creating base diagram libraries...${NC}"

# Create the mxClient.js if not available from download
if [ ! -f "js/diagrams/src/js/mxClient.js" ]; then
    echo -e "${YELLOW}Creating custom mxClient.js...${NC}"
    cat > js/diagrams/mxClient.js << 'EOL'
/**
 * Simplified mxGraph implementation for Portnox diagrams
 * This provides the core functionality needed for network diagrams
 */

// Define the core mxGraph namespaces and classes
var mxClient = {
    VERSION: '4.2.2',
    IS_IE: navigator.userAgent.indexOf('MSIE') >= 0,
    IS_IE11: !!navigator.userAgent.match(/Trident\/7\./),
    IS_EDGE: !!navigator.userAgent.match(/Edge\//),
    IS_SVG: navigator.userAgent.indexOf('Firefox/') >= 0 || navigator.userAgent.indexOf('Chrome/') >= 0 || document.documentMode >= 9,
    
    isBrowserSupported: function() {
        return this.IS_SVG || document.createElement('canvas').getContext != null;
    }
};

// Constants for styling
var mxConstants = {
    VERTEX_SELECTION_COLOR: '#00a8ff',
    EDGE_SELECTION_COLOR: '#00a8ff',
    VERTEX_SELECTION_STROKEWIDTH: 2,
    EDGE_SELECTION_STROKEWIDTH: 2,
    DEFAULT_FONTSIZE: 12,
    DEFAULT_FONTFAMILY: 'Arial',
    DEFAULT_STARTSIZE: 40,
    RECTANGLE_ROUNDING_FACTOR: 0.15,
    LINE_ARCSIZE: 20,
    ARROW_SPACING: 10,
    ARROW_WIDTH: 10,
    ARROW_SIZE: 30,
    PAGE_FORMAT_A4_PORTRAIT: { width: 827, height: 1169 },
    PAGE_FORMAT_A4_LANDSCAPE: { width: 1169, height: 827 },
    NONE: 'none',
    STYLE_SHAPE: 'shape',
    STYLE_PERIMETER: 'perimeter',
    STYLE_STROKECOLOR: 'strokeColor',
    STYLE_FILLCOLOR: 'fillColor',
    STYLE_GRADIENTCOLOR: 'gradientColor',
    STYLE_GRADIENT_DIRECTION: 'gradientDirection',
    STYLE_OPACITY: 'opacity',
    STYLE_FONTCOLOR: 'fontColor',
    STYLE_FONTFAMILY: 'fontFamily',
    STYLE_FONTSIZE: 'fontSize',
    STYLE_FONTSTYLE: 'fontStyle',
    STYLE_SPACING: 'spacing',
    STYLE_STARTSIZE: 'startSize',
    STYLE_ENDSIZE: 'endSize',
    STYLE_ROUNDED: 'rounded',
    STYLE_CURVED: 'curved',
    STYLE_ARCSIZE: 'arcSize',
    STYLE_ABSOLUTE_ARCSIZE: 'absoluteArcSize',
    STYLE_INDICATOR_SHAPE: 'indicatorShape',
    STYLE_INDICATOR_WIDTH: 'indicatorWidth',
    STYLE_INDICATOR_HEIGHT: 'indicatorHeight',
    STYLE_INDICATOR_COLOR: 'indicatorColor',
    STYLE_ALIGN: 'align',
    STYLE_VERTICAL_ALIGN: 'verticalAlign',
    STYLE_SHADOW: 'shadow',
    STYLE_SEGMENT: 'segment',
    STYLE_LABEL_BACKGROUNDCOLOR: 'labelBackgroundColor',
    STYLE_LABEL_BORDERCOLOR: 'labelBorderColor',
    STYLE_LABEL_PADDING: 'labelPadding',
    STYLE_IMAGE_ASPECT: 'imageAspect',
    STYLE_IMAGE_ALIGN: 'imageAlign',
    STYLE_IMAGE_VERTICAL_ALIGN: 'imageVerticalAlign',
    STYLE_NOLABEL: 'noLabel',
    STYLE_NOEDGESTYLE: 'noEdgeStyle',
    STYLE_MARGIN: 'margin',
    STYLE_PARENT: 'parent',
    STYLE_SOURCE_PORT: 'sourcePort',
    STYLE_TARGET_PORT: 'targetPort',
    STYLE_PORT_CONSTRAINT: 'portConstraint',
    STYLE_PORT_CONSTRAINT_ROTATION: 'portConstraintRotation',
    STYLE_SOURCE_PORT_CONSTRAINT: 'sourcePortConstraint',
    STYLE_TARGET_PORT_CONSTRAINT: 'targetPortConstraint',
    STYLE_OVERFLOW: 'overflow',
    STYLE_ORTHOGONAL: 'orthogonal',
    STYLE_EXIT_X: 'exitX',
    STYLE_EXIT_Y: 'exitY',
    STYLE_EXIT_DX: 'exitDx',
    STYLE_EXIT_DY: 'exitDy',
    STYLE_EXIT_PERIMETER: 'exitPerimeter',
    STYLE_ENTRY_X: 'entryX',
    STYLE_ENTRY_Y: 'entryY',
    STYLE_ENTRY_DX: 'entryDx',
    STYLE_ENTRY_DY: 'entryDy',
    STYLE_ENTRY_PERIMETER: 'entryPerimeter',
    STYLE_WHITE_SPACE: 'whiteSpace',
    STYLE_ROTATION: 'rotation',
    STYLE_FILLSTYLE: 'fillStyle',
    STYLE_POINTER_EVENTS: 'pointerEvents',
    STYLE_SWIMLANE_FILLCOLOR: 'swimlaneFillColor',
    STYLE_SWIMLANE_LINE: 'swimlaneLine',
    STYLE_SWIMLANE_HEAD_SIZE: 'swimlaneHeadSize',
    STYLE_MARGIN_LEFT: 'marginLeft',
    STYLE_MARGIN_TOP: 'marginTop',
    STYLE_MARGIN_RIGHT: 'marginRight',
    STYLE_MARGIN_BOTTOM: 'marginBottom',
    STYLE_DASHED: 'dashed',
    STYLE_DASH_PATTERN: 'dashPattern',
    STYLE_ROUNDED_CORNERS: 'roundedCorners',
    STYLE_ROUNDED_TOP_LEFT: 'roundedTopLeft',
    STYLE_ROUNDED_TOP_RIGHT: 'roundedTopRight',
    STYLE_ROUNDED_BOTTOM_LEFT: 'roundedBottomLeft',
    STYLE_ROUNDED_BOTTOM_RIGHT: 'roundedBottomRight',
    STYLE_HORIZONTAL: 'horizontal',
    STYLE_DIRECTION: 'direction',
    STYLE_ANCHOR_POINT_DIRECTION: 'anchorPointDirection',
    STYLE_TEXT_DIRECTION: 'textDirection',
    STYLE_ELBOW: 'elbow',
    STYLE_FONTATTRIBUTE: 'fontAttribute',
    STYLE_SHAPE_FILLCOLOR: 'shapeFillColor',
    STYLE_SHAPE_STROKECOLOR: 'shapeStrokeColor',
    STYLE_SHAPE_STROKEWIDTH: 'shapeStrokeWidth',
    STYLE_STROKEWIDTH: 'strokeWidth',
    STYLE_IMAGE: 'image',
    STYLE_IMAGE_WIDTH: 'imageWidth',
    STYLE_IMAGE_HEIGHT: 'imageHeight',
    STYLE_IMAGE_BACKGROUND: 'imageBackground',
    STYLE_IMAGE_BORDER: 'imageBorder',
    STYLE_FLIPH: 'flipH',
    STYLE_FLIPV: 'flipV',
    STYLE_ASPECT: 'aspect',
    STYLE_INCLUDE_CHILDREN: 'includeChildren',
    STYLE_HORIZONTAL_ALIGN: 'horizontalAlign',
    STYLE_VERTICAL_ALIGN: 'verticalAlign',
    STYLE_VERTICAL_LABEL_POSITION: 'verticalLabelPosition',
    STYLE_LABEL_POSITION: 'labelPosition',
    STYLE_GLASS: 'glass',
    ALIGN_LEFT: 'left',
    ALIGN_CENTER: 'center',
    ALIGN_RIGHT: 'right',
    ALIGN_TOP: 'top',
    ALIGN_MIDDLE: 'middle',
    ALIGN_BOTTOM: 'bottom',
    DIRECTION_NORTH: 'north',
    DIRECTION_SOUTH: 'south',
    DIRECTION_EAST: 'east',
    DIRECTION_WEST: 'west',
    DIRECTION_MASK_NONE: 0,
    DIRECTION_MASK_WEST: 1,
    DIRECTION_MASK_NORTH: 2,
    DIRECTION_MASK_SOUTH: 4,
    DIRECTION_MASK_EAST: 8,
    DIRECTION_MASK_ALL: 15,
    ELBOW_VERTICAL: 'vertical',
    ELBOW_HORIZONTAL: 'horizontal',
    ANCHOR_POINT_DIRECTION_VERTICAL: 'vertical',
    ANCHOR_POINT_DIRECTION_HORIZONTAL: 'horizontal',
    ANCHOR_POINT_DIRECTION_AUTOMATIC: 'auto',
    TEXT_DIRECTION_DEFAULT: '',
    TEXT_DIRECTION_AUTO: 'auto',
    TEXT_DIRECTION_LTR: 'ltr',
    TEXT_DIRECTION_RTL: 'rtl',
    OVERFLOW_VISIBLE: 'visible',
    OVERFLOW_HIDDEN: 'hidden',
    OVERFLOW_FILL: 'fill',
    OVERFLOW_WIDTH: 'width',
    OVERFLOW_AUTO: 'auto',
    SHAPE_RECTANGLE: 'rectangle',
    SHAPE_ELLIPSE: 'ellipse',
    SHAPE_DOUBLE_ELLIPSE: 'doubleEllipse',
    SHAPE_RHOMBUS: 'rhombus',
    SHAPE_LINE: 'line',
    SHAPE_IMAGE: 'image',
    SHAPE_ARROW: 'arrow',
    SHAPE_LABEL: 'label',
    SHAPE_CYLINDER: 'cylinder',
    SHAPE_SWIMLANE: 'swimlane',
    SHAPE_CONNECTOR: 'connector',
    SHAPE_ACTOR: 'actor',
    SHAPE_CLOUD: 'cloud',
    SHAPE_TRIANGLE: 'triangle',
    SHAPE_HEXAGON: 'hexagon',
    ARROW_CLASSIC: 'classic',
    ARROW_CLASSIC_THIN: 'classicThin',
    ARROW_BLOCK: 'block',
    ARROW_BLOCK_THIN: 'blockThin',
    ARROW_OPEN: 'open',
    ARROW_OPEN_THIN: 'openThin',
    ARROW_OVAL: 'oval',
    ARROW_DIAMOND: 'diamond',
    ARROW_DIAMOND_THIN: 'diamondThin',
    PD_POINTS: 'points',
    POINTS: 'points',
    SVG_CRISP_EDGES: true
};

// Perimeter types
var mxPerimeter = {
    RectanglePerimeter: 'rectanglePerimeter',
    EllipsePerimeter: 'ellipsePerimeter',
    RhombusPerimeter: 'rhombusPerimeter',
    TrianglePerimeter: 'trianglePerimeter',
    ShapePerimeter: 'shapePerimeter'
};

// Edge routing styles
var mxEdgeStyle = {
    ElbowConnector: 'elbowConnector',
    EntityRelation: 'entityRelationEdgeStyle',
    Loop: 'loopEdgeStyle',
    SideToSide: 'sideToSideEdgeStyle',
    TopToBottom: 'topToBottomEdgeStyle',
    OrthConnector: 'orthConnector',
    SegmentConnector: 'segmentConnector'
};

// Event handlers
var mxEvent = {
    NONE: 'none',
    CLICK: 'click',
    DBLCLICK: 'dblclick',
    MOUSE_DOWN: 'mouseDown',
    MOUSE_MOVE: 'mouseMove',
    MOUSE_UP: 'mouseUp',
    ACTIVATE: 'activate',
    RESIZE_START: 'resizeStart',
    RESIZE: 'resize',
    RESIZE_END: 'resizeEnd',
    MOVE_START: 'moveStart',
    MOVE: 'move',
    MOVE_END: 'moveEnd',
    PAN_START: 'panStart',
    PAN: 'pan',
    PAN_END: 'panEnd',
    MINIMIZE: 'minimize',
    NORMALIZE: 'normalize',
    MAXIMIZE: 'maximize',
    HIDE: 'hide',
    SHOW: 'show',
    CLOSE: 'close',
    DESTROY: 'destroy',
    REFRESH: 'refresh',
    SIZE: 'size',
    SELECT: 'select',
    FIRED: 'fired',
    FIRE_MOUSE_EVENT: 'fireMouseEvent',
    GESTURE: 'gesture',
    TAP_AND_HOLD: 'tapAndHold',
    GET: 'get',
    RECEIVE: 'receive',
    CONNECT: 'connect',
    DISCONNECT: 'disconnect',
    SUSPEND: 'suspend',
    RESUME: 'resume',
    MARK: 'mark',
    ROOT: 'root',
    POST: 'post',
    OPEN: 'open',
    SAVE: 'save',
    BEFORE_ADD_VERTEX: 'beforeAddVertex',
    ADD_VERTEX: 'addVertex',
    AFTER_ADD_VERTEX: 'afterAddVertex',
    DONE: 'done',
    EXECUTE: 'execute',
    EXECUTED: 'executed',
    BEGIN_UPDATE: 'beginUpdate',
    START_EDIT: 'startEdit',
    END_UPDATE: 'endUpdate',
    END_EDIT: 'endEdit',
    BEFORE_UNDO: 'beforeUndo',
    UNDO: 'undo',
    REDO: 'redo',
    CHANGE: 'change',
    NOTIFY: 'notify',
    LAYOUT_CELLS: 'layoutCells',
    CLICK: 'click',
    SCALE: 'scale',
    TRANSLATE: 'translate',
    SCALE_AND_TRANSLATE: 'scaleAndTranslate',
    UP: 'up',
    DOWN: 'down',
    ADD: 'add',
    REMOVE: 'remove',
    CLEAR: 'clear',
    ADD_CELLS: 'addCells',
    CELLS_ADDED: 'cellsAdded',
    MOVE_CELLS: 'moveCells',
    CELLS_MOVED: 'cellsMoved',
    RESIZE_CELLS: 'resizeCells',
    CELLS_RESIZED: 'cellsResized',
    TOGGLE_CELLS: 'toggleCells',
    CELLS_TOGGLED: 'cellsToggled',
    ORDER_CELLS: 'orderCells',
    CELLS_ORDERED: 'cellsOrdered',
    REMOVE_CELLS: 'removeCells',
    CELLS_REMOVED: 'cellsRemoved',
    GROUP_CELLS: 'groupCells',
    UNGROUP_CELLS: 'ungroupCells',
    REMOVE_CELLS_FROM_PARENT: 'removeCellsFromParent',
    FOLD_CELLS: 'foldCells',
    CELLS_FOLDED: 'cellsFolded',
    ALIGN_CELLS: 'alignCells',
    LABEL_CHANGED: 'labelChanged',
    CONNECT_CELL: 'connectCell',
    CELL_CONNECTED: 'cellConnected',
    SPLIT_EDGE: 'splitEdge',
    FLIP_EDGE: 'flipEdge',
    START_EDITING: 'startEditing',
    EDITING_STARTED: 'editingStarted',
    EDITING_STOPPED: 'editingStopped',
    ADD_OVERLAY: 'addOverlay',
    REMOVE_OVERLAY: 'removeOverlay',
    UPDATE_CELL_SIZE: 'updateCellSize',
    ESCAPE: 'escape',
    DOUBLE_CLICK: 'doubleClick',
    START: 'start',
    RESET: 'reset',
    
    // Mouse event utilities
    consume: function(evt) {
        if (evt.preventDefault) {
            evt.preventDefault();
        }
        if (evt.stopPropagation) {
            evt.stopPropagation();
        }
    },
    
    // Utility functions
    isConsumed: function(evt) {
        return evt.isConsumed && evt.isConsumed();
    },
    
    isLeftMouseButton: function(evt) {
        return evt.button == 0 || evt.type == 'touchstart';
    },
    
    isRightMouseButton: function(evt) {
        return evt.button == 2;
    },
    
    isMiddleMouseButton: function(evt) {
        return evt.button == 1;
    },
    
    isControlDown: function(evt) {
        return evt.ctrlKey || (mxClient.IS_MAC && evt.metaKey);
    },
    
    isShiftDown: function(evt) {
        return evt.shiftKey;
    },
    
    isAltDown: function(evt) {
        return evt.altKey;
    },
    
    disableContextMenu: function(element) {
        element.oncontextmenu = function() { return false; };
    },
    
    addMouseWheelListener: function(listener, target) {
        if (target) {
            target.addEventListener('wheel', function(evt) {
                if (listener) {
                    listener(evt, evt.deltaY < 0);
                }
            });
        }
    }
};

// Core class representing the graph
function mxGraph(container) {
    this.container = container;
    this.model = new mxGraphModel();
    this.view = new mxGraphView(this);
    this.stylesheet = new mxStylesheet();
    this.cellRenderer = new mxCellRenderer();
    
    // Initialize SVG for rendering
    this.initializeSvg();
    
    // Set default styles
    this.initializeDefaultStyles();
}

mxGraph.prototype.initializeSvg = function() {
    // Create SVG root element
    this.svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
    this.svg.style.position = 'absolute';
    this.svg.style.overflow = 'hidden';
    this.svg.style.width = '100%';
    this.svg.style.height = '100%';
    
    // Create definitions section for markers, etc.
    this.defs = document.createElementNS('http://www.w3.org/2000/svg', 'defs');
    this.svg.appendChild(this.defs);
    
    // Create arrow marker for edges
    var marker = document.createElementNS('http://www.w3.org/2000/svg', 'marker');
    marker.setAttribute('id', 'arrowMarker');
    marker.setAttribute('viewBox', '0 0 10 10');
    marker.setAttribute('refX', '10');
    marker.setAttribute('refY', '5');
    marker.setAttribute('markerWidth', '6');
    marker.setAttribute('markerHeight', '6');
    marker.setAttribute('orient', 'auto');
    
    var path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
    path.setAttribute('d', 'M 0 0 L 10 5 L 0 10 z');
    path.setAttribute('fill', '#000000');
    
    marker.appendChild(path);
    this.defs.appendChild(marker);
    
    // Create the root group for cells
    this.root = document.createElementNS('http://www.w3.org/2000/svg', 'g');
    this.svg.appendChild(this.root);
    
    // Add SVG to container
    this.container.appendChild(this.svg);
};

mxGraph.prototype.initializeDefaultStyles = function() {
    // Default vertex style
    var vertexStyle = {};
    vertexStyle[mxConstants.STYLE_SHAPE] = mxConstants.SHAPE_RECTANGLE;
    vertexStyle[mxConstants.STYLE_PERIMETER] = mxPerimeter.RectanglePerimeter;
    vertexStyle[mxConstants.STYLE_STROKECOLOR] = '#000000';
    vertexStyle[mxConstants.STYLE_FILLCOLOR] = '#FFFFFF';
    vertexStyle[mxConstants.STYLE_FONTCOLOR] = '#000000';
    vertexStyle[mxConstants.STYLE_ALIGN] = mxConstants.ALIGN_CENTER;
    vertexStyle[mxConstants.STYLE_VERTICAL_ALIGN] = mxConstants.ALIGN_MIDDLE;
    vertexStyle[mxConstants.STYLE_FONTSIZE] = mxConstants.DEFAULT_FONTSIZE;
    vertexStyle[mxConstants.STYLE_FONTSTYLE] = 0;
    vertexStyle[mxConstants.STYLE_ROUNDED] = false;
    this.stylesheet.defaultVertexStyle = vertexStyle;
    
    // Default edge style
    var edgeStyle = {};
    edgeStyle[mxConstants.STYLE_STROKECOLOR] = '#000000';
    edgeStyle[mxConstants.STYLE_FONTCOLOR] = '#000000';
    edgeStyle[mxConstants.STYLE_ALIGN] = mxConstants.ALIGN_CENTER;
    edgeStyle[mxConstants.STYLE_FONTSIZE] = mxConstants.DEFAULT_FONTSIZE;
    edgeStyle[mxConstants.STYLE_FONTSTYLE] = 0;
    edgeStyle[mxConstants.STYLE_ENDARROW] = mxConstants.ARROW_CLASSIC;
    this.stylesheet.defaultEdgeStyle = edgeStyle;
};

mxGraph.prototype.setEnabled = function(enabled) {
    this.enabled = enabled;
};

mxGraph.prototype.setCellsEditable = function(editable) {
    this.cellsEditable = editable;
};

mxGraph.prototype.setCellsResizable = function(resizable) {
    this.cellsResizable = resizable;
};

mxGraph.prototype.setConnectable = function(connectable) {
    this.connectable = connectable;
};

mxGraph.prototype.setPanning = function(panning) {
    this.panning = panning;
};

mxGraph.prototype.setTooltips = function(tooltips) {
    this.tooltips = tooltips;
};

mxGraph.prototype.getStylesheet = function() {
    return this.stylesheet;
};

mxGraph.prototype.getModel = function() {
    return this.model;
};

mxGraph.prototype.getView = function() {
    return this.view;
};

mxGraph.prototype.getDefaultParent = function() {
    return this.model.getRoot().getChildAt(0);
};

mxGraph.prototype.insertVertex = function(parent, id, value, x, y, width, height, style) {
    var vertex = new mxCell(value, new mxGeometry(x, y, width, height), style);
    vertex.setVertex(true);
    vertex.setId(id || this.model.nextId());
    
    this.model.beginUpdate();
    try {
        this.model.add(parent, vertex);
        this.cellSizeUpdated(vertex, false);
        this.createSvgElement(vertex);
    } finally {
        this.model.endUpdate();
    }
    
    return vertex;
};

mxGraph.prototype.insertEdge = function(parent, id, value, source, target, style) {
    var edge = new mxCell(value, new mxGeometry(), style);
    edge.setEdge(true);
    edge.setId(id || this.model.nextId());
    edge.setSource(source);
    edge.setTarget(target);
    
    this.model.beginUpdate();
    try {
        this.model.add(parent, edge);
        this.createSvgElement(edge);
    } finally {
        this.model.endUpdate();
    }
    
    return edge;
};

mxGraph.prototype.removeCells = function(cells) {
    this.model.beginUpdate();
    try {
        if (!cells) {
            cells = this.model.getRoot().children;
        }
        
        for (var i = 0; i < cells.length; i++) {
            this.model.remove(cells[i]);
            
            // Remove SVG element
            var elem = document.getElementById(cells[i].id);
            if (elem) {
                elem.parentNode.removeChild(elem);
            }
        }
    } finally {
        this.model.endUpdate();
    }
};

mxGraph.prototype.createSvgElement = function(cell) {
    if (cell.isVertex()) {
        // Create group for vertex
        var g = document.createElementNS('http://www.w3.org/2000/svg', 'g');
        g.setAttribute('id', cell.id);
        
        // Apply style
        var style = this.getCellStyle(cell);
        var shape = style[mxConstants.STYLE_SHAPE] || mxConstants.SHAPE_RECTANGLE;
        
        if (shape === mxConstants.SHAPE_RECTANGLE) {
            var rect = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
            rect.setAttribute('x', cell.geometry.x);
            rect.setAttribute('y', cell.geometry.y);
            rect.setAttribute('width', cell.geometry.width);
            rect.setAttribute('height', cell.geometry.height);
            rect.setAttribute('fill', style[mxConstants.STYLE_FILLCOLOR] || '#FFFFFF');
            rect.setAttribute('stroke', style[mxConstants.STYLE_STROKECOLOR] || '#000000');
            
            if (style[mxConstants.STYLE_ROUNDED] === true) {
                rect.setAttribute('rx', '5');
                rect.setAttribute('ry', '5');
            }
            
            g.appendChild(rect);
        } else if (shape === mxConstants.SHAPE_ELLIPSE) {
            var ellipse = document.createElementNS('http://www.w3.org/2000/svg', 'ellipse');
            ellipse.setAttribute('cx', cell.geometry.x + cell.geometry.width / 2);
            ellipse.setAttribute('cy', cell.geometry.y + cell.geometry.height / 2);
            ellipse.setAttribute('rx', cell.geometry.width / 2);
            ellipse.setAttribute('ry', cell.geometry.height / 2);
            ellipse.setAttribute('fill', style[mxConstants.STYLE_FILLCOLOR] || '#FFFFFF');
            ellipse.setAttribute('stroke', style[mxConstants.STYLE_STROKECOLOR] || '#000000');
            
            g.appendChild(ellipse);
        } else if (shape === mxConstants.SHAPE_IMAGE) {
            var img = document.createElementNS('http://www.w3.org/2000/svg', 'image');
            img.setAttribute('x', cell.geometry.x);
            img.setAttribute('y', cell.geometry.y);
            img.setAttribute('width', cell.geometry.width);
            img.setAttribute('height', cell.geometry.height);
            img.setAttributeNS('http://www.w3.org/1999/xlink', 'xlink:href', style[mxConstants.STYLE_IMAGE]);
            
            g.appendChild(img);
        }
        
        // Add label if cell has value
        if (cell.value) {
            var text = document.createElementNS('http://www.w3.org/2000/svg', 'text');
            text.setAttribute('x', cell.geometry.x + cell.geometry.width / 2);
            text.setAttribute('y', cell.geometry.y + cell.geometry.height / 2);
            text.setAttribute('text-anchor', 'middle');
            text.setAttribute('dominant-baseline', 'middle');
            text.setAttribute('fill', style[mxConstants.STYLE_FONTCOLOR] || '#000000');
            text.setAttribute('font-family', style[mxConstants.STYLE_FONTFAMILY] || 'Arial');
            text.setAttribute('font-size', style[mxConstants.STYLE_FONTSIZE] || '12px');
            
            // Handle vertical label position
            var verticalLabelPos = style[mxConstants.STYLE_VERTICAL_LABEL_POSITION];
            if (verticalLabelPos === 'top') {
                text.setAttribute('y', cell.geometry.y - 5);
            } else if (verticalLabelPos === 'bottom') {
                text.setAttribute('y', cell.geometry.y + cell.geometry.height + 15);
            }
            
            text.textContent = cell.value;
            g.appendChild(text);
        }
        
        this.root.appendChild(g);
    } else if (cell.isEdge()) {
        // Create edge element
        var g = document.createElementNS('http://www.w3.org/2000/svg', 'g');
        g.setAttribute('id', cell.id);
        
        var source = cell.source;
        var target = cell.target;
        
        if (source && target) {
            var sourceGeo = source.geometry;
            var targetGeo = target.geometry;
            
            var sourceX = sourceGeo.x + sourceGeo.width / 2;
            var sourceY = sourceGeo.y + sourceGeo.height / 2;
            var targetX = targetGeo.x + targetGeo.width / 2;
            var targetY = targetGeo.y + targetGeo.height / 2;
            
            // Create line for edge
            var line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
            line.setAttribute('x1', sourceX);
            line.setAttribute('y1', sourceY);
            line.setAttribute('x2', targetX);
            line.setAttribute('y2', targetY);
            line.setAttribute('stroke', '#000000');
            line.setAttribute('stroke-width', '1');
            
            // Apply arrow marker
            line.setAttribute('marker-end', 'url(#arrowMarker)');
            
            g.appendChild(line);
            
            // Add label if edge has value
            if (cell.value) {
                var text = document.createElementNS('http://www.w3.org/2000/svg', 'text');
                text.setAttribute('x', (sourceX + targetX) / 2);
                text.setAttribute('y', (sourceY + targetY) / 2 - 5);
                text.setAttribute('text-anchor', 'middle');
                text.setAttribute('dominant-baseline', 'middle');
                text.setAttribute('fill', '#000000');
                text.setAttribute('font-family', 'Arial');
                text.setAttribute('font-size', '12px');
                text.textContent = cell.value;
                
                // Add background rectangle for better readability
                var bbox = text.getBBox && text.getBBox();
                if (bbox) {
                    var rect = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
                    rect.setAttribute('x', bbox.x - 2);
                    rect.setAttribute('y', bbox.y - 2);
                    rect.setAttribute('width', bbox.width + 4);
                    rect.setAttribute('height', bbox.height + 4);
                    rect.setAttribute('fill', '#FFFFFF');
                    rect.setAttribute('fill-opacity', '0.8');
                    g.appendChild(rect);
                }
                
                g.appendChild(text);
            }
        }
        
        this.root.appendChild(g);
    }
};

mxGraph.prototype.getCellStyle = function(cell) {
    var style = {};
    
    if (cell.style) {
        // Parse style string (format is name=value;name=value;...)
        var pairs = cell.style.split(';');
        
        for (var i = 0; i < pairs.length; i++) {
            var pair = pairs[i].split('=');
            
            if (pair.length === 2) {
                style[pair[0]] = pair[1];
            }
        }
    }
    
    // Apply default style based on cell type
    var defaultStyle = cell.isVertex() ? 
                      this.stylesheet.defaultVertexStyle : 
                      this.stylesheet.defaultEdgeStyle;
    
    for (var key in defaultStyle) {
        if (style[key] === undefined) {
            style[key] = defaultStyle[key];
        }
    }
    
    return style;
};

mxGraph.prototype.cellSizeUpdated = function(cell, ignoreChildren) {
    // This is a placeholder for size updating
};

mxGraph.prototype.zoomIn = function() {
    this.view.scale *= 1.2;
    this.view.refresh();
};

mxGraph.prototype.zoomOut = function() {
    this.view.scale /= 1.2;
    this.view.refresh();
};

mxGraph.prototype.zoomActual = function() {
    this.view.scale = 1;
    this.view.refresh();
};

mxGraph.prototype.center = function(horizontal, vertical, cx, cy) {
    // Center the graph
    var bounds = this.getGraphBounds();
    if (bounds.width > 0 && bounds.height > 0) {
        var x = bounds.x + bounds.width / 2;
        var y = bounds.y + bounds.height / 2;
        
        var scale = this.view.scale;
        var dx = (this.container.clientWidth / 2 - x * scale);
        var dy = (this.container.clientHeight / 2 - y * scale);
        
        this.view.translate.x = dx / scale;
        this.view.translate.y = dy / scale;
        
        this.view.refresh();
    }
};

mxGraph.prototype.getGraphBounds = function() {
    var cells = this.model.cells;
    var minX = Infinity;
    var minY = Infinity;
    var maxX = -Infinity;
    var maxY = -Infinity;
    
    for (var id in cells) {
        var cell = cells[id];
        
        if (cell.geometry) {
            var geo = cell.geometry;
            
            minX = Math.min(minX, geo.x);
            minY = Math.min(minY, geo.y);
            maxX = Math.max(maxX, geo.x + (geo.width || 0));
            maxY = Math.max(maxY, geo.y + (geo.height || 0));
        }
    }
    
    if (minX === Infinity) {
        minX = 0;
        minY = 0;
        maxX = this.container.clientWidth;
        maxY = this.container.clientHeight;
    }
    
    return new mxRectangle(minX, minY, maxX - minX, maxY - minY);
};

// mxGraphView handles view state
function mxGraphView(graph) {
    this.graph = graph;
    this.scale = 1;
    this.translate = { x: 0, y: 0 };
    this.bounds = new mxRectangle(0, 0, 0, 0);
}

mxGraphView.prototype.refresh = function() {
    if (this.graph.root) {
        // Update the transform
        this.graph.root.setAttribute('transform', 
            'translate(' + this.translate.x * this.scale + ',' + this.translate.y * this.scale + ')' +
            'scale(' + this.scale + ')');
    }
};

mxGraphView.prototype.getState = function(cell) {
    // Simplified state object for export
    return {
        cell: cell,
        style: this.graph.getCellStyle(cell)
    };
};

// mxGraphModel manages data model
function mxGraphModel() {
    this.root = new mxCell();
    this.cells = {};
    this.nextId = 0;
    
    // Add default parent
    var child = new mxCell();
    this.root.insert(child);
    
    this.cells[this.root.id] = this.root;
    this.cells[child.id] = child;
}

mxGraphModel.prototype.getRoot = function() {
    return this.root;
};

mxGraphModel.prototype.getCell = function(id) {
    return this.cells[id];
};

mxGraphModel.prototype.add = function(parent, child) {
    if (parent && child) {
        parent.insert(child);
        this.cells[child.id] = child;
        
        return child;
    }
    
    return null;
};

mxGraphModel.prototype.remove = function(cell) {
    if (cell) {
        // Remove from parent
        if (cell.parent) {
            cell.parent.remove(cell);
        }
        
        // Remove from cells
        delete this.cells[cell.id];
        
        return cell;
    }
    
    return null;
};

mxGraphModel.prototype.beginUpdate = function() {
    // Placeholder for transaction start
};

mxGraphModel.prototype.endUpdate = function() {
    // Placeholder for transaction end
};

mxGraphModel.prototype.clear = function() {
    // Clear all cells except root
    this.root.children = [];
    this.cells = {};
    this.cells[this.root.id] = this.root;
    
    // Add default parent
    var child = new mxCell();
    this.root.insert(child);
    this.cells[child.id] = child;
    
    this.nextId = 0;
};

mxGraphModel.prototype.setRoot = function(root) {
    this.root = root;
    this.cells = {};
    this.nextId = 0;
    
    this.addCell(root);
};

mxGraphModel.prototype.addCell = function(cell) {
    if (cell) {
        this.cells[cell.id] = cell;
        
        if (cell.children) {
            for (var i = 0; i < cell.children.length; i++) {
                this.addCell(cell.children[i]);
            }
        }
    }
};

// mxCell represents vertices and edges
function mxCell(value, geometry, style) {
    this.value = value;
    this.geometry = geometry || new mxGeometry();
    this.style = style || '';
    this.vertex = false;
    this.edge = false;
    this.id = 'mx-' + (++mxCell.prototype.idCounter);
    this.parent = null;
    this.source = null;
    this.target = null;
    this.children = [];
}

mxCell.prototype.idCounter = 0;

mxCell.prototype.setId = function(id) {
    this.id = id;
};

mxCell.prototype.setVertex = function(vertex) {
    this.vertex = vertex;
};

mxCell.prototype.setEdge = function(edge) {
    this.edge = edge;
};

mxCell.prototype.isVertex = function() {
    return this.vertex;
};

mxCell.prototype.isEdge = function() {
    return this.edge;
};

mxCell.prototype.setSource = function(source) {
    this.source = source;
};

mxCell.prototype.setTarget = function(target) {
    this.target = target;
};

mxCell.prototype.insert = function(child) {
    if (child) {
        child.parent = this;
        this.children.push(child);
    }
    
    return child;
};

mxCell.prototype.remove = function(child) {
    if (child && child.parent === this) {
        var index = this.children.indexOf(child);
        
        if (index >= 0) {
            this.children.splice(index, 1);
            child.parent = null;
        }
    }
    
    return child;
};

mxCell.prototype.getChildAt = function(index) {
    return this.children[index];
};

// mxGeometry represents cell geometry
function mxGeometry(x, y, width, height) {
    this.x = x || 0;
    this.y = y || 0;
    this.width = width || 0;
    this.height = height || 0;
}

// mxRectangle represents a rectangle
function mxRectangle(x, y, width, height) {
    this.x = x || 0;
    this.y = y || 0;
    this.width = width || 0;
    this.height = height || 0;
}

// mxStylesheet manages styles
function mxStylesheet() {
    this.styles = {};
    this.defaultVertexStyle = {};
    this.defaultEdgeStyle = {};
}

mxStylesheet.prototype.getDefaultVertexStyle = function() {
    return this.defaultVertexStyle;
};

mxStylesheet.prototype.getDefaultEdgeStyle = function() {
    return this.defaultEdgeStyle;
};

mxStylesheet.prototype.putCellStyle = function(name, style) {
    this.styles[name] = style;
};

// mxCellRenderer renders cells
function mxCellRenderer() {}

// mxUtils provides utility functions
var mxUtils = {
    createXmlDocument: function() {
        return document.implementation.createDocument(null, 'svg', null);
    },
    
    parseXml: function(xml) {
        var parser = new DOMParser();
        return parser.parseFromString(xml, 'text/xml');
    },
    
    getXml: function(node) {
        return new XMLSerializer().serializeToString(node);
    },
    
    isNode: function(value) {
        return value != null && typeof value.nodeType === 'number';
    },
    
    error: function(msg) {
        console.error(msg);
    }
};

// mxImageExport for exporting graphs as images
function mxImageExport() {}

mxImageExport.prototype.drawState = function(state, canvas) {
    if (state && canvas) {
        var cell = state.cell;
        
        if (cell.isVertex()) {
            // Draw vertex
            var style = state.style;
            var x = cell.geometry.x;
            var y = cell.geometry.y;
            var width = cell.geometry.width;
            var height = cell.geometry.height;
            
            if (style[mxConstants.STYLE_SHAPE] === mxConstants.SHAPE_RECTANGLE) {
                canvas.rect(x, y, width, height);
                canvas.fill();
                canvas.stroke();
            } else if (style[mxConstants.STYLE_SHAPE] === mxConstants.SHAPE_ELLIPSE) {
                canvas.ellipse(x + width/2, y + height/2, width/2, height/2);
                canvas.fill();
                canvas.stroke();
            } else if (style[mxConstants.STYLE_SHAPE] === mxConstants.SHAPE_IMAGE) {
                canvas.image(x, y, width, height, style[mxConstants.STYLE_IMAGE]);
            }
            
            // Draw label
            if (cell.value) {
                canvas.text(x + width/2, y + height/2, cell.value);
            }
        } else if (cell.isEdge()) {
            // Draw edge
            var source = cell.source;
            var target = cell.target;
            
            if (source && target) {
                var sourceGeo = source.geometry;
                var targetGeo = target.geometry;
                
                var x1 = sourceGeo.x + sourceGeo.width/2;
                var y1 = sourceGeo.y + sourceGeo.height/2;
                var x2 = targetGeo.x + targetGeo.width/2;
                var y2 = targetGeo.y + targetGeo.height/2;
                
                canvas.line(x1, y1, x2, y2);
                canvas.stroke();
                
                // Draw arrow
                var dx = x2 - x1;
                var dy = y2 - y1;
                var dist = Math.sqrt(dx * dx + dy * dy);
                
                if (dist > 0) {
                    var nx = dx / dist;
                    var ny = dy / dist;
                    var arrowSize = 10;
                    
                    var ax = x2 - arrowSize * nx;
                    var ay = y2 - arrowSize * ny;
                    
                    canvas.begin();
                    canvas.moveTo(ax + arrowSize * ny / 3, ay - arrowSize * nx / 3);
                    canvas.lineTo(x2, y2);
                    canvas.lineTo(ax - arrowSize * ny / 3, ay + arrowSize * nx / 3);
                    canvas.stroke();
                }
                
                // Draw label
                if (cell.value) {
                    canvas.text((x1 + x2) / 2, (y1 + y2) / 2 - 5, cell.value);
                }
            }
        }
    }
};

// Canvas for image export
function mxImageCanvas2D(canvas) {
    this.canvas = canvas;
    this.ctx = canvas.getContext('2d');
    this.scale = 1;
    this.translateX = 0;
    this.translateY = 0;
}

mxImageCanvas2D.prototype.translate = function(dx, dy) {
    this.translateX = dx;
    this.translateY = dy;
};

mxImageCanvas2D.prototype.rect = function(x, y, w, h) {
    x = this.translateX + x * this.scale;
    y = this.translateY + y * this.scale;
    w = w * this.scale;
    h = h * this.scale;
    
    this.ctx.beginPath();
    this.ctx.rect(x, y, w, h);
};

mxImageCanvas2D.prototype.ellipse = function(x, y, w, h) {
    x = this.translateX + x * this.scale;
    y = this.translateY + y * this.scale;
    w = w * this.scale;
    h = h * this.scale;
    
    this.ctx.beginPath();
    this.ctx.ellipse(x, y, w, h, 0, 0, 2 * Math.PI);
};

mxImageCanvas2D.prototype.image = function(x, y, w, h, src) {
    x = this.translateX + x * this.scale;
    y = this.translateY + y * this.scale;
    w = w * this.scale;
    h = h * this.scale;
    
    var img = new Image();
    img.src = src;
    
    var self = this;
    img.onload = function() {
        self.ctx.drawImage(img, x, y, w, h);
    };
};

mxImageCanvas2D.prototype.text = function(x, y, text) {
    x = this.translateX + x * this.scale;
    y = this.translateY + y * this.scale;
    
    this.ctx.fillStyle = '#000000';
    this.ctx.textAlign = 'center';
    this.ctx.textBaseline = 'middle';
    this.ctx.fillText(text, x, y);
};

mxImageCanvas2D.prototype.begin = function() {
    this.ctx.beginPath();
};

mxImageCanvas2D.prototype.moveTo = function(x, y) {
    x = this.translateX + x * this.scale;
    y = this.translateY + y * this.scale;
    
    this.ctx.moveTo(x, y);
};

mxImageCanvas2D.prototype.lineTo = function(x, y) {
    x = this.translateX + x * this.scale;
    y = this.translateY + y * this.scale;
    
    this.ctx.lineTo(x, y);
};

mxImageCanvas2D.prototype.line = function(x1, y1, x2, y2) {
    x1 = this.translateX + x1 * this.scale;
    y1 = this.translateY + y1 * this.scale;
    x2 = this.translateX + x2 * this.scale;
    y2 = this.translateY + y2 * this.scale;
    
    this.ctx.beginPath();
    this.ctx.moveTo(x1, y1);
    this.ctx.lineTo(x2, y2);
};

mxImageCanvas2D.prototype.fill = function() {
    this.ctx.fill();
};

mxImageCanvas2D.prototype.stroke = function() {
    this.ctx.stroke();
};

// SVG Canvas for SVG export
function mxSvgCanvas2D(root) {
    this.root = root || document.createElementNS('http://www.w3.org/2000/svg', 'svg');
    this.defs = null;
    this.styleEnabled = false;
    this.node = null;
    this.compressed = false;
    this.translate = { x: 0, y: 0 };
    this.scale = 1;
}

mxSvgCanvas2D.prototype.getDocument = function() {
    return this.root;
};

mxSvgCanvas2D.prototype.createDefs = function() {
    if (this.defs == null) {
        this.defs = document.createElementNS('http://www.w3.org/2000/svg', 'defs');
        
        if (this.root.firstChild != null) {
            this.root.insertBefore(this.defs, this.root.firstChild);
        } else {
            this.root.appendChild(this.defs);
        }
    }
    
    return this.defs;
};

// Stencil registry for loading stencil XML files
var mxStencilRegistry = {
    packages: {},
    
    loadStencilSet: function(filename, callback) {
        var req = new XMLHttpRequest();
        req.open('GET', filename);
        
        req.onreadystatechange = function() {
            if (req.readyState == 4) {
                if (req.status == 200) {
                    var doc = mxUtils.parseXml(req.responseText);
                    var name = doc.documentElement.getAttribute('name');
                    
                    if (name != null) {
                        mxStencilRegistry.packages[name] = doc;
                        
                        if (callback) {
                            callback(true);
                        }
                    }
                } else {
                    if (callback) {
                        callback(false);
                    }
                }
            }
        };
        
        req.send();
    }
};

// Editor for managing diagrams
function mxEditor() {
    this.graph = new mxGraph();
}

// Codec for encoding/decoding XML
function mxCodec(document) {
    this.document = document || mxUtils.createXmlDocument();
}

mxCodec.prototype.encode = function(obj) {
    // Simple implementation to encode object to XML
    var node = this.document.createElement('object');
    
    if (obj instanceof mxGraphModel) {
        node = this.document.createElement('mxGraphModel');
        
        var rootNode = this.document.createElement('root');
        node.appendChild(rootNode);
        
        for (var i = 0; i < obj.root.children.length; i++) {
            var child = obj.root.children[i];
            var childNode = this.encodeCell(child);
            rootNode.appendChild(childNode);
        }
    }
    
    return node;
};

mxCodec.prototype.encodeCell = function(cell) {
    var node = this.document.createElement('mxCell');
    
    if (cell.id != null) {
        node.setAttribute('id', cell.id);
    }
    
    if (cell.value != null) {
        node.setAttribute('value', cell.value);
    }
    
    if (cell.style != null) {
        node.setAttribute('style', cell.style);
    }
    
    if (cell.vertex) {
        node.setAttribute('vertex', '1');
        
        if (cell.geometry) {
            var geo = cell.geometry;
            var geom = this.document.createElement('mxGeometry');
            geom.setAttribute('x', geo.x);
            geom.setAttribute('y', geo.y);
            geom.setAttribute('width', geo.width);
            geom.setAttribute('height', geo.height);
            node.appendChild(geom);
        }
    } else if (cell.edge) {
        node.setAttribute('edge', '1');
        
        if (cell.source) {
            node.setAttribute('source', cell.source.id);
        }
        
        if (cell.target) {
            node.setAttribute('target', cell.target.id);
        }
    }
    
    for (var i = 0; i < cell.children.length; i++) {
        var child = cell.children[i];
        var childNode = this.encodeCell(child);
        node.appendChild(childNode);
    }
    
    return node;
};

mxCodec.prototype.decode = function(node) {
    var model = new mxGraphModel();
    
    if (node.nodeName === 'mxGraphModel') {
        var rootNode = node.getElementsByTagName('root')[0];
        
        if (rootNode) {
            var root = new mxCell();
            model.setRoot(root);
            
            // Decode all child cells
            var childNodes = rootNode.childNodes;
            
            for (var i = 0; i < childNodes.length; i++) {
                var cellNode = childNodes[i];
                
                if (cellNode.nodeType === 1) {
                    var cell = this.decodeCell(cellNode, model);
                    root.insert(cell);
                }
            }
        }
    }
    
    return model;
};

mxCodec.prototype.decodeCell = function(node, model) {
    var cell = new mxCell();
    
    if (node.hasAttribute('id')) {
        cell.id = node.getAttribute('id');
    }
    
    if (node.hasAttribute('value')) {
        cell.value = node.getAttribute('value');
    }
    
    if (node.hasAttribute('style')) {
        cell.style = node.getAttribute('style');
    }
    
    if (node.hasAttribute('vertex') && node.getAttribute('vertex') === '1') {
        cell.vertex = true;
        
        // Decode geometry
        var geoNodes = node.getElementsByTagName('mxGeometry');
        
        if (geoNodes.length > 0) {
            var geoNode = geoNodes[0];
            var geo = new mxGeometry();
            
            if (geoNode.hasAttribute('x')) {
                geo.x = parseFloat(geoNode.getAttribute('x'));
            }
            
            if (geoNode.hasAttribute('y')) {
                geo.y = parseFloat(geoNode.getAttribute('y'));
            }
            
            if (geoNode.hasAttribute('width')) {
                geo.width = parseFloat(geoNode.getAttribute('width'));
            }
            
            if (geoNode.hasAttribute('height')) {
                geo.height = parseFloat(geoNode.getAttribute('height'));
            }
            
            cell.geometry = geo;
        }
    } else if (node.hasAttribute('edge') && node.getAttribute('edge') === '1') {
        cell.edge = true;
        
        // Store source and target references for later resolution
        if (node.hasAttribute('source')) {
            var sourceId = node.getAttribute('source');
            cell._sourceId = sourceId;
        }
        
        if (node.hasAttribute('target')) {
            var targetId = node.getAttribute('target');
            cell._targetId = targetId;
        }
    }
    
    // Decode all child cells
    var childNodes = node.childNodes;
    
    for (var i = 0; i < childNodes.length; i++) {
        var childNode = childNodes[i];
        
        if (childNode.nodeType === 1 && childNode.nodeName === 'mxCell') {
            var childCell = this.decodeCell(childNode, model);
            cell.insert(childCell);
        }
    }
    
    return cell;
};
EOL
else
    echo -e "${GREEN}Using existing mxClient.js from download${NC}"
    cp js/diagrams/src/js/mxClient.js js/diagrams/mxClient.js
fi

# Create the diagram generator
echo -e "${YELLOW}Creating diagram generator for Portnox NAC...${NC}"
cat > js/diagrams/diagram-generator.js << 'EOL'
/**
 * Portnox NAC Diagram Generator for UaXSupreme
 * @version 1.0.0
 * 
 * A comprehensive diagram generator for Portnox Cloud NAC deployments
 * that includes support for all vendors, authentication methods, and
 * deployment scenarios.
 */

const PortnoxDiagramGenerator = (function() {
    // Private variables
    let graph = null;
    let currentConfig = null;
    let diagramContainer = null;
    
    // Initialize the diagram generator
    const initialize = function(containerId) {
        diagramContainer = document.getElementById(containerId);
        if (!diagramContainer) {
            console.error('Container element not found:', containerId);
            return false;
        }
        
        try {
            if (typeof mxClient === 'undefined') {
                console.error('mxClient is not defined. Make sure draw.io libraries are loaded.');
                return false;
            }
            
            if (!mxClient.isBrowserSupported()) {
                console.error('Browser is not supported by mxGraph');
                return false;
            }
            
            // Create a graph inside the given container
            graph = new mxGraph(diagramContainer);
            
            // Configure graph behavior
            configureGraph();
            
            // Load stencil libraries
            loadStencils();
            
            return true;
        } catch (e) {
            console.error('Failed to initialize diagram generator:', e);
            return false;
        }
    };
    
    // Configure graph display and behavior
    const configureGraph = function() {
        // Enable basic features
        graph.setEnabled(true);
        graph.setPanning(true);
        graph.setTooltips(true);
        graph.setConnectable(true);
        graph.setCellsEditable(false);
        
        // Create default styles
        const stylesheet = graph.getStylesheet();
        
        // Default vertex style
        const vertexStyle = stylesheet.getDefaultVertexStyle();
        vertexStyle[mxConstants.STYLE_SHAPE] = mxConstants.SHAPE_RECTANGLE;
        vertexStyle[mxConstants.STYLE_PERIMETER] = mxPerimeter.RectanglePerimeter;
        vertexStyle[mxConstants.STYLE_FONTCOLOR] = '#000000';
        vertexStyle[mxConstants.STYLE_FILLCOLOR] = '#FFFFFF';
        vertexStyle[mxConstants.STYLE_STROKECOLOR] = '#000000';
        vertexStyle[mxConstants.STYLE_ROUNDED] = true;
        vertexStyle[mxConstants.STYLE_SHADOW] = false;
        
        // Default edge style
        const edgeStyle = stylesheet.getDefaultEdgeStyle();
        edgeStyle[mxConstants.STYLE_STROKECOLOR] = '#333333';
        edgeStyle[mxConstants.STYLE_FONTCOLOR] = '#333333';
        edgeStyle[mxConstants.STYLE_LABEL_BACKGROUNDCOLOR] = '#FFFFFF';
        edgeStyle[mxConstants.STYLE_ROUNDED] = true;
        edgeStyle[mxConstants.STYLE_STROKEWIDTH] = 2;
        edgeStyle[mxConstants.STYLE_ENDARROW] = mxConstants.ARROW_CLASSIC;
        
        // Add custom styles for Portnox components
        stylesheet.putCellStyle('portnoxCloud', {
            [mxConstants.STYLE_SHAPE]: mxConstants.SHAPE_IMAGE,
            [mxConstants.STYLE_IMAGE]: 'images/stencils/portnox/portnox_cloud.svg',
            [mxConstants.STYLE_VERTICAL_LABEL_POSITION]: 'bottom',
            [mxConstants.STYLE_VERTICAL_ALIGN]: 'top'
        });
        
        stylesheet.putCellStyle('portnoxRadius', {
            [mxConstants.STYLE_SHAPE]: mxConstants.SHAPE_IMAGE,
            [mxConstants.STYLE_IMAGE]: 'images/stencils/portnox/portnox_radius.svg',
            [mxConstants.STYLE_VERTICAL_LABEL_POSITION]: 'bottom',
            [mxConstants.STYLE_VERTICAL_ALIGN]: 'top'
        });
        
        // Custom switch styles for each vendor
        const vendors = ['cisco', 'aruba', 'juniper', 'hp', 'dell', 'extreme', 'arista', 'fortinet', 'paloalto'];
        vendors.forEach(vendor => {
            stylesheet.putCellStyle(`${vendor}Switch`, {
                [mxConstants.STYLE_SHAPE]: mxConstants.SHAPE_IMAGE,
                [mxConstants.STYLE_IMAGE]: `images/stencils/vendors/${vendor}/switch.svg`,
                [mxConstants.STYLE_VERTICAL_LABEL_POSITION]: 'bottom',
                [mxConstants.STYLE_VERTICAL_ALIGN]: 'top'
            });
            
            stylesheet.putCellStyle(`${vendor}Router`, {
                [mxConstants.STYLE_SHAPE]: mxConstants.SHAPE_IMAGE,
                [mxConstants.STYLE_IMAGE]: `images/stencils/vendors/${vendor}/router.svg`,
                [mxConstants.STYLE_VERTICAL_LABEL_POSITION]: 'bottom',
                [mxConstants.STYLE_VERTICAL_ALIGN]: 'top'
            });
            
            stylesheet.putCellStyle(`${vendor}Firewall`, {
                [mxConstants.STYLE_SHAPE]: mxConstants.SHAPE_IMAGE,
                [mxConstants.STYLE_IMAGE]: `images/stencils/vendors/${vendor}/firewall.svg`,
                [mxConstants.STYLE_VERTICAL_LABEL_POSITION]: 'bottom',
                [mxConstants.STYLE_VERTICAL_ALIGN]: 'top'
            });
            
            stylesheet.putCellStyle(`${vendor}WirelessAP`, {
                [mxConstants.STYLE_SHAPE]: mxConstants.SHAPE_IMAGE,
                [mxConstants.STYLE_IMAGE]: `images/stencils/vendors/${vendor}/wireless_ap.svg`,
                [mxConstants.STYLE_VERTICAL_LABEL_POSITION]: 'bottom',
                [mxConstants.STYLE_VERTICAL_ALIGN]: 'top'
            });
        });
        
        // Add custom styles for authentication methods
        const authMethods = ['eap_tls', 'peap', 'eap_ttls', 'eap_fast', 'mab'];
        authMethods.forEach(method => {
            stylesheet.putCellStyle(`auth${method.replace('eap_', '').toUpperCase()}`, {
                [mxConstants.STYLE_SHAPE]: mxConstants.SHAPE_IMAGE,
                [mxConstants.STYLE_IMAGE]: `images/stencils/authentication/${method}.svg`,
                [mxConstants.STYLE_VERTICAL_LABEL_POSITION]: 'bottom',
                [mxConstants.STYLE_VERTICAL_ALIGN]: 'top'
            });
        });
        
        // Add device styles
        const devices = ['byod', 'iot', 'printer', 'phone', 'camera', 'desktop', 'server'];
        devices.forEach(device => {
            stylesheet.putCellStyle(`device${device.charAt(0).toUpperCase() + device.slice(1)}`, {
                [mxConstants.STYLE_SHAPE]: mxConstants.SHAPE_IMAGE,
                [mxConstants.STYLE_IMAGE]: `images/stencils/devices/${device}.svg`,
                [mxConstants.STYLE_VERTICAL_LABEL_POSITION]: 'bottom',
                [mxConstants.STYLE_VERTICAL_ALIGN]: 'top'
            });
        });
        
        // Enable mouse wheel for zoom
        mxEvent.addMouseWheelListener(function(evt, up) {
            if (mxEvent.isControlDown(evt)) {
                if (up) {
                    graph.zoomIn();
                } else {
                    graph.zoomOut();
                }
                mxEvent.consume(evt);
            }
        });
    };
    
    // Load custom stencil sets
    const loadStencils = function() {
        try {
            // Load Portnox stencils
            mxStencilRegistry.loadStencilSet('js/diagrams/stencils/portnox.xml');
            console.log('Loaded Portnox stencils');
            
            // Load authentication stencils
            mxStencilRegistry.loadStencilSet('js/diagrams/stencils/authentication.xml');
            console.log('Loaded Authentication stencils');
            
            // Load device stencils
            mxStencilRegistry.loadStencilSet('js/diagrams/stencils/devices.xml');
            console.log('Loaded Device stencils');
            
            // Load vendor stencils
            mxStencilRegistry.loadStencilSet('js/diagrams/stencils/vendors.xml');
            console.log('Loaded Vendor stencils');
            
            // Load cloud service stencils
            mxStencilRegistry.loadStencilSet('js/diagrams/stencils/cloud_services.xml');
            console.log('Loaded Cloud service stencils');
        } catch (e) {
            console.error('Error loading stencils:', e);
        }
    };
    
    // Generate a diagram based on the specified type and configuration
    const generateDiagram = function(config, diagramType) {
        try {
            // Store current configuration
            currentConfig = config || {};
            
            // Clear existing diagram
            graph.getModel().beginUpdate();
            try {
                // Remove all cells
                graph.removeCells(graph.getChildCells(graph.getDefaultParent()));
            } finally {
                graph.getModel().endUpdate();
            }
            
            // Generate the diagram based on the specified type
            switch (diagramType) {
                case 'basic_cloud_deployment':
                    generateBasicCloudDeployment();
                    break;
                case 'enterprise_deployment':
                    generateEnterpriseDeployment();
                    break;
                case 'healthcare_deployment':
                    generateHealthcareDeployment();
                    break;
                case 'education_deployment':
                    generateEducationDeployment();
                    break;
                case 'retail_deployment':
                    generateRetailDeployment();
                    break;
                case 'manufacturing_deployment':
                    generateManufacturingDeployment();
                    break;
                case 'government_deployment':
                    generateGovernmentDeployment();
                    break;
                case 'financial_deployment':
                    generateFinancialDeployment();
                    break;
                case 'eap_tls_authentication':
                    generateEapTlsAuthenticationFlow();
                    break;
                case 'byod_onboarding':
                    generateByodOnboardingFlow();
                    break;
                case 'dynamic_vlan_assignment':
                    generateDynamicVlanAssignment();
                    break;
                case 'multi_vendor_deployment':
                    generateMultiVendorDeployment();
                    break;
                case 'high_security_deployment':
                    generateHighSecurityDeployment();
                    break;
                case 'cloud_integration':
                    generateCloudIntegration();
                    break;
                case 'multi_site_deployment':
                    generateMultiSiteDeployment();
                    break;
                case 'iot_segmentation':
                    generateIoTSegmentation();
                    break;
                case 'guest_access':
                    generateGuestAccess();
                    break;
                default:
                    generateBasicCloudDeployment();
            }
            
            return true;
        } catch (e) {
            console.error('Error generating diagram:', e);
            return false;
        }
    };
    
    // Basic Portnox Cloud Deployment diagram
    const generateBasicCloudDeployment = function() {
        const parent = graph.getDefaultParent();
        
        graph.getModel().beginUpdate();
        try {
            // Add Portnox Cloud
            const portnoxCloud = graph.insertVertex(parent, null, 'Portnox Cloud', 
                350, 50, 150, 60, 'portnoxCloud');
            
            // Add RADIUS Server if enabled
            let radiusServer = null;
            if (currentConfig.showRadius !== false) {
                radiusServer = graph.insertVertex(parent, null, 'Portnox RADIUS', 
                    350, 180, 150, 60, 'portnoxRadius');
                
                // Connect Portnox Cloud to RADIUS
                graph.insertEdge(parent, null, 'API', portnoxCloud, radiusServer);
            }
            
            // Add Network
            const network = graph.insertVertex(parent, null, 'Corporate Network', 
                350, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // Connect RADIUS to Network if RADIUS is shown, otherwise connect Cloud directly
            if (radiusServer) {
                graph.insertEdge(parent, null, 'RADIUS', radiusServer, network);
            } else {
                graph.insertEdge(parent, null, 'RADIUS', portnoxCloud, network);
            }
            
            // Add network devices
            const vendor = currentConfig.vendor || 'cisco';
            const switchDevice = graph.insertVertex(parent, null, 'Switch', 
                200, 400, 60, 60, `${vendor}Switch`);
            
            const wirelessAP = graph.insertVertex(parent, null, 'Wireless AP', 
                500, 400, 60, 60, `${vendor}WirelessAP`);
            
            // Connect network devices to network
            graph.insertEdge(parent, null, '', switchDevice, network);
            graph.insertEdge(parent, null, '', wirelessAP, network);
            
            // Add client devices if enabled
            if (currentConfig.showClients !== false) {
                // Add wired clients
                const byodDevice = graph.insertVertex(parent, null, 'BYOD Device', 
                    120, 500, 60, 60, 'deviceByod');
                
                const iotDevice = graph.insertVertex(parent, null, 'IoT Device', 
                    220, 500, 60, 60, 'deviceIot');
                
                const printer = graph.insertVertex(parent, null, 'Printer', 
                    320, 500, 60, 60, 'devicePrinter');
                
                // Connect wired devices to switch
                graph.insertEdge(parent, null, '', byodDevice, switchDevice);
                graph.insertEdge(parent, null, '', iotDevice, switchDevice);
                graph.insertEdge(parent, null, '', printer, switchDevice);
                
                // Add wireless clients
                const wirelessClient = graph.insertVertex(parent, null, 'Wireless Client', 
                    500, 500, 60, 60, 'deviceByod');
                
                // Connect wireless device to AP
                graph.insertEdge(parent, null, '', wirelessClient, wirelessAP);
            }
            
            // Add authentication methods if enabled
            if (currentConfig.showAuth !== false) {
                const eapTls = graph.insertVertex(parent, null, 'EAP-TLS', 
                    600, 180, 100, 60, 'authTLS');
                
                if (radiusServer) {
                    graph.insertEdge(parent, null, 'Authentication', eapTls, radiusServer);
                } else {
                    graph.insertEdge(parent, null, 'Authentication', eapTls, portnoxCloud);
                }
            }
            
            // Add cloud services if enabled
            if (currentConfig.showCloud !== false) {
                const azureAD = graph.insertVertex(parent, null, 'Azure AD', 
                    600, 50, 60, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/cloud/azure/active_directory.svg;');
                
                graph.insertEdge(parent, null, 'Identity', azureAD, portnoxCloud);
            }
            
            // Center the graph
            graph.center(true, true, 0.5, 0.5);
        } finally {
            graph.getModel().endUpdate();
        }
    };
    
    // Enterprise deployment with high security and segmentation
    const generateEnterpriseDeployment = function() {
        const parent = graph.getDefaultParent();
        
        graph.getModel().beginUpdate();
        try {
            // Add title
            const title = graph.insertVertex(parent, null, 'Portnox Cloud Enterprise Deployment', 
                350, 20, 300, 30, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=16;fontStyle=1');
            
            // Add Portnox Cloud
            const portnoxCloud = graph.insertVertex(parent, null, 'Portnox Cloud', 
                350, 70, 150, 60, 'portnoxCloud');
            
            // Add RADIUS Servers (Primary and Secondary for redundancy)
            const radiusPrimary = graph.insertVertex(parent, null, 'Primary RADIUS', 
                250, 180, 150, 60, 'portnoxRadius');
            
            const radiusSecondary = graph.insertVertex(parent, null, 'Secondary RADIUS', 
                450, 180, 150, 60, 'portnoxRadius');
            
            // Connect Portnox Cloud to RADIUS servers
            graph.insertEdge(parent, null, 'API', portnoxCloud, radiusPrimary);
            graph.insertEdge(parent, null, 'API', portnoxCloud, radiusSecondary);
            
            // Add DMZ and Internal Networks
            const dmzNetwork = graph.insertVertex(parent, null, 'DMZ', 
                150, 300, 120, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#fff2cc;strokeColor=#d6b656;');
            
            const internalNetwork = graph.insertVertex(parent, null, 'Internal Network', 
                350, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#d5e8d4;strokeColor=#82b366;');
            
            const serverNetwork = graph.insertVertex(parent, null, 'Server Network', 
                550, 300, 120, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#e1d5e7;strokeColor=#9673a6;');
            
            // Connect RADIUS to Networks
            graph.insertEdge(parent, null, 'RADIUS', radiusPrimary, dmzNetwork);
            graph.insertEdge(parent, null, 'RADIUS', radiusPrimary, internalNetwork);
            graph.insertEdge(parent, null, 'RADIUS', radiusSecondary, internalNetwork);
            graph.insertEdge(parent, null, 'RADIUS', radiusSecondary, serverNetwork);
            
            // Add network devices
            const vendor = currentConfig.vendor || 'cisco';
            
            // DMZ Devices
            const dmzFirewall = graph.insertVertex(parent, null, 'DMZ Firewall', 
                150, 400, 60, 60, `${vendor}Firewall`);
            
            // Internal Devices
            const coreSwitch = graph.insertVertex(parent, null, 'Core Switch', 
                350, 400, 60, 60, `${vendor}Switch`);
            
            // Server Devices
            const serverSwitch = graph.insertVertex(parent, null, 'Server Switch', 
                550, 400, 60, 60, `${vendor}Switch`);
            
            // Connect network devices to networks
            graph.insertEdge(parent, null, '', dmzFirewall, dmzNetwork);
            graph.insertEdge(parent, null, '', coreSwitch, internalNetwork);
            graph.insertEdge(parent, null, '', serverSwitch, serverNetwork);
            
            // Add Access Layer
            const accessSwitch1 = graph.insertVertex(parent, null, 'Access Switch 1', 
                250, 500, 60, 60, `${vendor}Switch`);
            
            const accessSwitch2 = graph.insertVertex(parent, null, 'Access Switch 2', 
                350, 500, 60, 60, `${vendor}Switch`);
            
            const wirelessController = graph.insertVertex(parent, null, 'Wireless Controller', 
                450, 500, 60, 60, `${vendor}WirelessAP`);
            
            // Connect access layer to core
            graph.insertEdge(parent, null, '', accessSwitch1, coreSwitch);
            graph.insertEdge(parent, null, '', accessSwitch2, coreSwitch);
            graph.insertEdge(parent, null, '', wirelessController, coreSwitch);
            
            // Add client devices
            const desktop1 = graph.insertVertex(parent, null, 'Desktop', 
                200, 600, 60, 60, 'deviceDesktop');
            
            const desktop2 = graph.insertVertex(parent, null, 'Desktop', 
                300, 600, 60, 60, 'deviceDesktop');
            
            const wirelessAP1 = graph.insertVertex(parent, null, 'AP', 
                420, 600, 60, 60, `${vendor}WirelessAP`);
            
            const wirelessAP2 = graph.insertVertex(parent, null, 'AP', 
                500, 600, 60, 60, `${vendor}WirelessAP`);
            
            // Connect devices
            graph.insertEdge(parent, null, '', desktop1, accessSwitch1);
            graph.insertEdge(parent, null, '', desktop2, accessSwitch2);
            graph.insertEdge(parent, null, '', wirelessAP1, wirelessController);
            graph.insertEdge(parent, null, '', wirelessAP2, wirelessController);
            
            // Add server
            const server = graph.insertVertex(parent, null, 'Server', 
                550, 500, 60, 60, 'deviceServer');
            
            graph.insertEdge(parent, null, '', server, serverSwitch);
            
            // Add authentication methods
            const eapTls = graph.insertVertex(parent, null, 'EAP-TLS', 
                700, 150, 100, 60, 'authTLS');
            
            const mab = graph.insertVertex(parent, null, 'MAB', 
                700, 250, 100, 60, 'authMAB');
            
            graph.insertEdge(parent, null, 'Auth', eapTls, portnoxCloud);
            graph.insertEdge(parent, null, 'Auth', mab, portnoxCloud);
            
            // Add Identity Sources
            const azureAD = graph.insertVertex(parent, null, 'Azure AD', 
                700, 70, 60, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/cloud/azure/active_directory.svg;');
            
            graph.insertEdge(parent, null, 'Identity', azureAD, portnoxCloud);
            
            // Center the graph
            graph.center(true, true, 0.5, 0.5);
        } finally {
            graph.getModel().endUpdate();
        }
    };
    
    // Healthcare specific deployment
    const generateHealthcareDeployment = function() {
        const parent = graph.getDefaultParent();
        
        graph.getModel().beginUpdate();
        try {
            // Add title
            const title = graph.insertVertex(parent, null, 'Portnox Cloud Healthcare Deployment', 
                350, 20, 300, 30, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=16;fontStyle=1');
            
            // Add subtitle with focus on HIPAA compliance
            const subtitle = graph.insertVertex(parent, null, 'HIPAA Compliant NAC Solution', 
                350, 50, 200, 20, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;');
            
            // Add Portnox Cloud
            const portnoxCloud = graph.insertVertex(parent, null, 'Portnox Cloud', 
                350, 80, 150, 60, 'portnoxCloud');
            
            // Add RADIUS Servers (Primary and Secondary for redundancy)
            const radiusPrimary = graph.insertVertex(parent, null, 'Primary RADIUS', 
                250, 180, 150, 60, 'portnoxRadius');
            
            const radiusSecondary = graph.insertVertex(parent, null, 'Secondary RADIUS', 
                450, 180, 150, 60, 'portnoxRadius');
            
            // Connect Portnox Cloud to RADIUS servers
            graph.insertEdge(parent, null, 'API', portnoxCloud, radiusPrimary);
            graph.insertEdge(parent, null, 'API', portnoxCloud, radiusSecondary);
            
            // Add Segmented Networks
            const adminNetwork = graph.insertVertex(parent, null, 'Administrative Network', 
                150, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#d5e8d4;strokeColor=#82b366;');
            
            const clinicalNetwork = graph.insertVertex(parent, null, 'Clinical Network', 
                350, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#ffe6cc;strokeColor=#d79b00;');
            
            const medicalDevicesNetwork = graph.insertVertex(parent, null, 'Medical Devices Network', 
                550, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#f8cecc;strokeColor=#b85450;');
            
            // Connect RADIUS to Networks
            graph.insertEdge(parent, null, 'RADIUS', radiusPrimary, adminNetwork);
            graph.insertEdge(parent, null, 'RADIUS', radiusPrimary, clinicalNetwork);
            graph.insertEdge(parent, null, 'RADIUS', radiusSecondary, clinicalNetwork);
            graph.insertEdge(parent, null, 'RADIUS', radiusSecondary, medicalDevicesNetwork);
            
            // Add network devices
            const vendor = currentConfig.vendor || 'cisco';
            
            // Admin Network Devices
            const adminSwitch = graph.insertVertex(parent, null, 'Admin Switch', 
                150, 400, 60, 60, `${vendor}Switch`);
            
            // Clinical Network Devices
            const clinicalSwitch = graph.insertVertex(parent, null, 'Clinical Switch', 
                350, 400, 60, 60, `${vendor}Switch`);
            
            // Medical Devices Network
            const medicalSwitch = graph.insertVertex(parent, null, 'Medical Device Switch', 
                550, 400, 60, 60, `${vendor}Switch`);
            
            // Connect network devices to networks
            graph.insertEdge(parent, null, '', adminSwitch, adminNetwork);
            graph.insertEdge(parent, null, '', clinicalSwitch, clinicalNetwork);
            graph.insertEdge(parent, null, '', medicalSwitch, medicalDevicesNetwork);
            
            // Add client devices
            const adminComputer = graph.insertVertex(parent, null, 'Admin PC', 
                150, 500, 60, 60, 'deviceDesktop');
            
            const clinicalWorkstation = graph.insertVertex(parent, null, 'Clinical Workstation', 
                300, 500, 60, 60, 'deviceDesktop');
            
            const tablet = graph.insertVertex(parent, null, 'Medical Tablet', 
                400, 500, 60, 60, 'deviceByod');
            
            const mriMachine = graph.insertVertex(parent, null, 'MRI Machine', 
                500, 500, 60, 60, 'deviceIot');
            
            const patientMonitor = graph.insertVertex(parent, null, 'Patient Monitor', 
                600, 500, 60, 60, 'deviceIot');
            
            // Connect devices to switches
            graph.insertEdge(parent, null, '', adminComputer, adminSwitch);
            graph.insertEdge(parent, null, '', clinicalWorkstation, clinicalSwitch);
            graph.insertEdge(parent, null, '', tablet, clinicalSwitch);
            graph.insertEdge(parent, null, '', mriMachine, medicalSwitch);
            graph.insertEdge(parent, null, '', patientMonitor, medicalSwitch);
            
            // Add authentication methods
            const eapTls = graph.insertVertex(parent, null, 'EAP-TLS', 
                700, 150, 100, 60, 'authTLS');
            
            const mab = graph.insertVertex(parent, null, 'MAB', 
                700, 250, 100, 60, 'authMAB');
            
            graph.insertEdge(parent, null, 'Corporate Devices', eapTls, portnoxCloud);
            graph.insertEdge(parent, null, 'Medical Devices', mab, portnoxCloud);
            
            // Add compliance box
            const complianceBox = graph.insertVertex(parent, null, 
                'HIPAA Compliance Features:\n• Network Segmentation\n• Device Authentication\n• Continuous Monitoring\n• Audit Logging\n• Automated Remediation', 
                700, 350, 200, 120, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#fff2cc;strokeColor=#d6b656;align=left;');
            
            // Add Identity Sources
            const azureAD = graph.insertVertex(parent, null, 'Azure AD', 
                550, 80, 60, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/cloud/azure/active_directory.svg;');
            
            graph.insertEdge(parent, null, 'Identity', azureAD, portnoxCloud);
            
            // Center the graph
            graph.center(true, true, 0.5, 0.5);
        } finally {
            graph.getModel().endUpdate();
        }
    };
    
    // Education deployment with specific focus on campus environments
    const generateEducationDeployment = function() {
        const parent = graph.getDefaultParent();
        
        graph.getModel().beginUpdate();
        try {
            // Add title
            const title = graph.insertVertex(parent, null, 'Portnox Cloud Education Deployment', 
                350, 20, 300, 30, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=16;fontStyle=1');
            
            // Add subtitle focusing on campus environment
            const subtitle = graph.insertVertex(parent, null, 'Campus-Wide NAC Solution with BYOD Support', 
                350, 50, 300, 20, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;');
            
            // Add Portnox Cloud
            const portnoxCloud = graph.insertVertex(parent, null, 'Portnox Cloud', 
                350, 80, 150, 60, 'portnoxCloud');
            
            // Add RADIUS Server
            const radiusServer = graph.insertVertex(parent, null, 'Portnox RADIUS', 
                350, 180, 150, 60, 'portnoxRadius');
            
            // Connect Portnox Cloud to RADIUS
            graph.insertEdge(parent, null, 'API', portnoxCloud, radiusServer);
            
            // Add Campus Networks
            const studentNetwork = graph.insertVertex(parent, null, 'Student Network', 
                150, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#dae8fc;strokeColor=#6c8ebf;');
            
            const facultyNetwork = graph.insertVertex(parent, null, 'Faculty Network', 
                350, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#d5e8d4;strokeColor=#82b366;');
            
            const guestNetwork = graph.insertVertex(parent, null, 'Guest Network', 
                550, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#ffe6cc;strokeColor=#d79b00;');
            
            // Connect RADIUS to Networks
            graph.insertEdge(parent, null, 'RADIUS', radiusServer, studentNetwork);
            graph.insertEdge(parent, null, 'RADIUS', radiusServer, facultyNetwork);
            graph.insertEdge(parent, null, 'RADIUS', radiusServer, guestNetwork);
            
            // Add Campus Buildings with network devices
            const vendor = currentConfig.vendor || 'cisco';
            
            // Dorm Building
            const dormBuilding = graph.insertVertex(parent, null, 'Dormitory', 
                150, 400, 100, 60, 'shape=image;html=1;verticalAlign=top;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;imageAspect=0;aspect=fixed;image=images/stencils/network/building.svg;');
            
            // Academic Building
            const academicBuilding = graph.insertVertex(parent, null, 'Academic Building', 
                350, 400, 100, 60, 'shape=image;html=1;verticalAlign=top;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;imageAspect=0;aspect=fixed;image=images/stencils/network/building.svg;');
            
            // Library
            const libraryBuilding = graph.insertVertex(parent, null, 'Library', 
                550, 400, 100, 60, 'shape=image;html=1;verticalAlign=top;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;imageAspect=0;aspect=fixed;image=images/stencils/network/building.svg;');
            
            // Connect buildings to networks
            graph.insertEdge(parent, null, '', dormBuilding, studentNetwork);
            graph.insertEdge(parent, null, '', academicBuilding, facultyNetwork);
            graph.insertEdge(parent, null, '', libraryBuilding, guestNetwork);
            
            // Add access points
            const studentAP = graph.insertVertex(parent, null, 'Student AP', 
                150, 500, 60, 60, `${vendor}WirelessAP`);
            
            const facultyAP = graph.insertVertex(parent, null, 'Faculty AP', 
                350, 500, 60, 60, `${vendor}WirelessAP`);
            
            const guestAP = graph.insertVertex(parent, null, 'Guest AP', 
                550, 500, 60, 60, `${vendor}WirelessAP`);
            
            // Connect APs to buildings
            graph.insertEdge(parent, null, '', studentAP, dormBuilding);
            graph.insertEdge(parent, null, '', facultyAP, academicBuilding);
            graph.insertEdge(parent, null, '', guestAP, libraryBuilding);
            
            // Add client devices
            const studentLaptop = graph.insertVertex(parent, null, 'Student Laptop', 
                100, 600, 60, 60, 'deviceByod');
            
            const studentPhone = graph.insertVertex(parent, null, 'Student Phone', 
                200, 600, 60, 60, 'deviceByod');
            
            const facultyLaptop = graph.insertVertex(parent, null, 'Faculty Laptop', 
                350, 600, 60, 60, 'deviceDesktop');
            
            const guestDevice = graph.insertVertex(parent, null, 'Guest Device', 
                550, 600, 60, 60, 'deviceByod');
            
            // Connect devices to APs
            graph.insertEdge(parent, null, '', studentLaptop, studentAP);
            graph.insertEdge(parent, null, '', studentPhone, studentAP);
            graph.insertEdge(parent, null, '', facultyLaptop, facultyAP);
            graph.insertEdge(parent, null, '', guestDevice, guestAP);
            
            // Add authentication methods
            const eapTls = graph.insertVertex(parent, null, 'EAP-TLS', 
                700, 150, 100, 60, 'authTLS');
            
            const webAuth = graph.insertVertex(parent, null, 'Web Auth', 
                700, 250, 100, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/authentication/webauth.svg;');
            
            graph.insertEdge(parent, null, 'Secure Auth', eapTls, portnoxCloud);
            graph.insertEdge(parent, null, 'Guest Auth', webAuth, portnoxCloud);
            
            // Add features box
            const featuresBox = graph.insertVertex(parent, null, 
                'Education Features:\n• BYOD Onboarding\n• Guest Access Portal\n• Device Profiling\n• Role-Based Access\n• Self-Service Portal', 
                700, 350, 200, 120, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#d5e8d4;strokeColor=#82b366;align=left;');
            
            // Add Identity Sources
            const googleWorkspace = graph.insertVertex(parent, null, 'Google Workspace', 
                550, 80, 60, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/idp/google/workspace.svg;');
            
            graph.insertEdge(parent, null, 'Identity', googleWorkspace, portnoxCloud);
            
            // Center the graph
            graph.center(true, true, 0.5, 0.5);
        } finally {
            graph.getModel().endUpdate();
        }
    };
    
    // Retail deployment with POS and guest WiFi
    const generateRetailDeployment = function() {
        const parent = graph.getDefaultParent();
        
        graph.getModel().beginUpdate();
        try {
            // Add title
            const title = graph.insertVertex(parent, null, 'Portnox Cloud Retail Deployment', 
                350, 20, 300, 30, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=16;fontStyle=1');
            
            // Add subtitle focusing on PCI compliance
            const subtitle = graph.insertVertex(parent, null, 'PCI-DSS Compliant NAC Solution for Retail', 
                350, 50, 300, 20, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;');
            
            // Add Portnox Cloud
            const portnoxCloud = graph.insertVertex(parent, null, 'Portnox Cloud', 
                350, 80, 150, 60, 'portnoxCloud');
            
            // Add RADIUS Server
            const radiusServer = graph.insertVertex(parent, null, 'Portnox RADIUS', 
                350, 180, 150, 60, 'portnoxRadius');
            
            // Connect Portnox Cloud to RADIUS
            graph.insertEdge(parent, null, 'API', portnoxCloud, radiusServer);
            
            // Add Retail Networks
            const posNetwork = graph.insertVertex(parent, null, 'POS Network (PCI)', 
                150, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#f8cecc;strokeColor=#b85450;');
            
            const corporateNetwork = graph.insertVertex(parent, null, 'Corporate Network', 
                350, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#d5e8d4;strokeColor=#82b366;');
            
            const guestNetwork = graph.insertVertex(parent, null, 'Guest WiFi', 
                550, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#dae8fc;strokeColor=#6c8ebf;');
            
            // Connect RADIUS to Networks
            graph.insertEdge(parent, null, 'RADIUS', radiusServer, posNetwork);
            graph.insertEdge(parent, null, 'RADIUS', radiusServer, corporateNetwork);
            graph.insertEdge(parent, null, 'RADIUS', radiusServer, guestNetwork);
            
            // Add Retail Store components
            const vendor = currentConfig.vendor || 'cisco';
            
            // Store Layout
            const storeLayout = graph.insertVertex(parent, null, 'Retail Store', 
                350, 400, 300, 200, 'shape=rectangle;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // POS Area
            const posArea = graph.insertVertex(parent, null, 'POS Area', 
                200, 450, 100, 60, 'shape=rectangle;fillColor=#ffe6cc;strokeColor=#d79b00;parent=storeLayout;');
            
            // Back Office
            const backOffice = graph.insertVertex(parent, null, 'Back Office', 
                350, 450, 100, 60, 'shape=rectangle;fillColor=#e1d5e7;strokeColor=#9673a6;parent=storeLayout;');
            
            // Customer Area
            const customerArea = graph.insertVertex(parent, null, 'Customer Area', 
                500, 450, 100, 60, 'shape=rectangle;fillColor=#dae8fc;strokeColor=#6c8ebf;parent=storeLayout;');
            
            // Add network devices
            const posSwitch = graph.insertVertex(parent, null, 'POS Switch', 
                200, 520, 60, 40, `${vendor}Switch;parent=storeLayout;`);
            
            const officeSwitch = graph.insertVertex(parent, null, 'Office Switch', 
                350, 520, 60, 40, `${vendor}Switch;parent=storeLayout;`);
            
            const guestAP = graph.insertVertex(parent, null, 'Guest AP', 
                500, 520, 60, 40, `${vendor}WirelessAP;parent=storeLayout;`);
            
            // Connect devices to areas
            graph.insertEdge(parent, null, '', posSwitch, posArea, 'parent=storeLayout;');
            graph.insertEdge(parent, null, '', officeSwitch, backOffice, 'parent=storeLayout;');
            graph.insertEdge(parent, null, '', guestAP, customerArea, 'parent=storeLayout;');
            
            // Connect networks to areas
            graph.insertEdge(parent, null, '', posNetwork, posSwitch);
            graph.insertEdge(parent, null, '', corporateNetwork, officeSwitch);
            graph.insertEdge(parent, null, '', guestNetwork, guestAP);
            
            // Add endpoint devices
            const posTerminal = graph.insertVertex(parent, null, 'POS Terminal', 
                150, 650, 60, 60, 'deviceIot');
            
            const backOfficePC = graph.insertVertex(parent, null, 'Office PC', 
                350, 650, 60, 60, 'deviceDesktop');
            
            const customerPhone = graph.insertVertex(parent, null, 'Customer Phone', 
                550, 650, 60, 60, 'deviceByod');
            
            // Connect endpoints to network devices
            graph.insertEdge(parent, null, '', posTerminal, posSwitch);
            graph.insertEdge(parent, null, '', backOfficePC, officeSwitch);
            graph.insertEdge(parent, null, '', customerPhone, guestAP);
            
            // Add authentication methods
            const eapTls = graph.insertVertex(parent, null, 'EAP-TLS', 
                700, 150, 100, 60, 'authTLS');
            
            const webAuth = graph.insertVertex(parent, null, 'Web Auth', 
                700, 250, 100, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/authentication/webauth.svg;');
            
            graph.insertEdge(parent, null, 'Corporate Auth', eapTls, portnoxCloud);
            graph.insertEdge(parent, null, 'Guest Auth', webAuth, portnoxCloud);
            
            // Add PCI compliance box
            const complianceBox = graph.insertVertex(parent, null, 
                'PCI-DSS Compliance Features:\n• Network Segmentation\n• Device Authentication\n• Continuous Monitoring\n• Restricted Access\n• Guest Isolation', 
                700, 350, 200, 120, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#f8cecc;strokeColor=#b85450;align=left;');
            
            // Center the graph
            graph.center(true, true, 0.5, 0.5);
        } finally {
            graph.getModel().endUpdate();
        }
    };
    
    // Manufacturing deployment with OT/IT segmentation
    const generateManufacturingDeployment = function() {
        const parent = graph.getDefaultParent();
        
        graph.getModel().beginUpdate();
        try {
            // Add title
            const title = graph.insertVertex(parent, null, 'Portnox Cloud Manufacturing Deployment', 
                350, 20, 300, 30, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=16;fontStyle=1');
            
            // Add subtitle focusing on OT/IT convergence
            const subtitle = graph.insertVertex(parent, null, 'OT/IT Convergence with Secure NAC', 
                350, 50, 300, 20, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;');
            
            // Add Portnox Cloud
            const portnoxCloud = graph.insertVertex(parent, null, 'Portnox Cloud', 
                350, 80, 150, 60, 'portnoxCloud');
            
            // Add RADIUS Server
            const radiusServer = graph.insertVertex(parent, null, 'Portnox RADIUS', 
                350, 180, 150, 60, 'portnoxRadius');
            
            // Connect Portnox Cloud to RADIUS
            graph.insertEdge(parent, null, 'API', portnoxCloud, radiusServer);
            
            // Add Manufacturing Networks
            const itNetwork = graph.insertVertex(parent, null, 'IT Network', 
                150, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#d5e8d4;strokeColor=#82b366;');
            
            const otNetwork = graph.insertVertex(parent, null, 'OT Network', 
                350, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#f8cecc;strokeColor=#b85450;');
            
            const dmzNetwork = graph.insertVertex(parent, null, 'DMZ', 
                550, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#fff2cc;strokeColor=#d6b656;');
            
            // Connect RADIUS to Networks
            graph.insertEdge(parent, null, 'RADIUS', radiusServer, itNetwork);
            graph.insertEdge(parent, null, 'RADIUS', radiusServer, otNetwork);
            graph.insertEdge(parent, null, 'RADIUS', radiusServer, dmzNetwork);
            
            // Add Plant Floor Layout
            const vendor = currentConfig.vendor || 'cisco';
            
            // Plant Layout
            const plantLayout = graph.insertVertex(parent, null, 'Manufacturing Plant', 
                350, 400, 500, 200, 'shape=rectangle;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // IT Area
            const itArea = graph.insertVertex(parent, null, 'IT & Office Area', 
                200, 450, 100, 60, 'shape=rectangle;fillColor=#d5e8d4;strokeColor=#82b366;parent=plantLayout;');
            
            // Production Floor
            const productionArea = graph.insertVertex(parent, null, 'Production Floor', 
                350, 450, 100, 60, 'shape=rectangle;fillColor=#f8cecc;strokeColor=#b85450;parent=plantLayout;');
            
            // External Access
            const externalArea = graph.insertVertex(parent, null, 'External Access', 
                500, 450, 100, 60, 'shape=rectangle;fillColor=#fff2cc;strokeColor=#d6b656;parent=plantLayout;');
            
            // Add network devices
            const itSwitch = graph.insertVertex(parent, null, 'Office Switch', 
                200, 520, 60, 40, `${vendor}Switch;parent=plantLayout;`);
            
            const industrialSwitch = graph.insertVertex(parent, null, 'Industrial Switch', 
                350, 520, 60, 40, `${vendor}Switch;parent=plantLayout;`);
            
            const dmzFirewall = graph.insertVertex(parent, null, 'DMZ Firewall', 
                500, 520, 60, 40, `${vendor}Firewall;parent=plantLayout;`);
            
            // Connect devices to areas
            graph.insertEdge(parent, null, '', itSwitch, itArea, 'parent=plantLayout;');
            graph.insertEdge(parent, null, '', industrialSwitch, productionArea, 'parent=plantLayout;');
            graph.insertEdge(parent, null, '', dmzFirewall, externalArea, 'parent=plantLayout;');
            
            // Connect networks to areas
            graph.insertEdge(parent, null, '', itNetwork, itSwitch);
            graph.insertEdge(parent, null, '', otNetwork, industrialSwitch);
            graph.insertEdge(parent, null, '', dmzNetwork, dmzFirewall);
            
            // Add endpoint devices
            const officePC = graph.insertVertex(parent, null, 'Office PC', 
                150, 650, 60, 60, 'deviceDesktop');
            
            const plc = graph.insertVertex(parent, null, 'PLC Controller', 
                300, 650, 60, 60, 'deviceIot');
            
            const hmi = graph.insertVertex(parent, null, 'HMI Terminal', 
                400, 650, 60, 60, 'deviceIot');
            
            const vendor = graph.insertVertex(parent, null, 'Vendor Access', 
                550, 650, 60, 60, 'deviceByod');
            
            // Connect endpoints to network devices
            graph.insertEdge(parent, null, '', officePC, itSwitch);
            graph.insertEdge(parent, null, '', plc, industrialSwitch);
            graph.insertEdge(parent, null, '', hmi, industrialSwitch);
            graph.insertEdge(parent, null, '', vendor, dmzFirewall);
            
            // Add authentication methods
            const eapTls = graph.insertVertex(parent, null, 'EAP-TLS', 
                700, 150, 100, 60, 'authTLS');
            
            const mab = graph.insertVertex(parent, null, 'MAB', 
                700, 250, 100, 60, 'authMAB');
            
            graph.insertEdge(parent, null, 'IT Auth', eapTls, portnoxCloud);
            graph.insertEdge(parent, null, 'OT Auth', mab, portnoxCloud);
            
            // Add security features box
            const featuresBox = graph.insertVertex(parent, null, 
                'OT/IT Security Features:\n• Network Segmentation\n• Protocol Filtering\n• Device Profiling\n• MAC Authentication\n• Vendor Access Control', 
                700, 350, 200, 120, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#ffe6cc;strokeColor=#d79b00;align=left;');
            
            // Center the graph
            graph.center(true, true, 0.5, 0.5);
        } finally {
            graph.getModel().endUpdate();
        }
    };
    
    // Government deployment with high security requirements
    const generateGovernmentDeployment = function() {
        const parent = graph.getDefaultParent();
        
        graph.getModel().beginUpdate();
        try {
            // Add title
            const title = graph.insertVertex(parent, null, 'Portnox Cloud Government Deployment', 
                350, 20, 300, 30, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=16;fontStyle=1');
            
            // Add subtitle focusing on high security
            const subtitle = graph.insertVertex(parent, null, 'High Security NAC Implementation with FIPS Compliance', 
                350, 50, 350, 20, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;');
            
            // Add Portnox Cloud
            const portnoxCloud = graph.insertVertex(parent, null, 'Portnox Cloud', 
                350, 80, 150, 60, 'portnoxCloud');
            
            // Add RADIUS Servers (Primary and Secondary for redundancy)
            const radiusPrimary = graph.insertVertex(parent, null, 'Primary RADIUS', 
                250, 180, 150, 60, 'portnoxRadius');
            
            const radiusSecondary = graph.insertVertex(parent, null, 'Secondary RADIUS', 
                450, 180, 150, 60, 'portnoxRadius');
            
            // Connect Portnox Cloud to RADIUS servers
            graph.insertEdge(parent, null, 'API', portnoxCloud, radiusPrimary);
            graph.insertEdge(parent, null, 'API', portnoxCloud, radiusSecondary);
            
            // Add Security Zones
            const highSecurityZone = graph.insertVertex(parent, null, 'High Security Zone', 
                150, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#f8cecc;strokeColor=#b85450;');
            
            const standardZone = graph.insertVertex(parent, null, 'Standard Zone', 
                350, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#d5e8d4;strokeColor=#82b366;');
            
            const publicZone = graph.insertVertex(parent, null, 'Public Access Zone', 
                550, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#dae8fc;strokeColor=#6c8ebf;');
            
            // Connect RADIUS to Zones
            graph.insertEdge(parent, null, 'RADIUS', radiusPrimary, highSecurityZone);
            graph.insertEdge(parent, null, 'RADIUS', radiusPrimary, standardZone);
            graph.insertEdge(parent, null, 'RADIUS', radiusSecondary, standardZone);
            graph.insertEdge(parent, null, 'RADIUS', radiusSecondary, publicZone);
            
            // Add network infrastructure
            const vendor = currentConfig.vendor || 'cisco';
            
            // Firewalls for zone isolation
            const highSecurityFirewall = graph.insertVertex(parent, null, 'HS Firewall', 
                150, 400, 60, 60, `${vendor}Firewall`);
            
            const standardFirewall = graph.insertVertex(parent, null, 'Standard Firewall', 
                350, 400, 60, 60, `${vendor}Firewall`);
            
            const publicFirewall = graph.insertVertex(parent, null, 'Public Firewall', 
                550, 400, 60, 60, `${vendor}Firewall`);
            
            // Connect firewalls to zones
            graph.insertEdge(parent, null, '', highSecurityFirewall, highSecurityZone);
            graph.insertEdge(parent, null, '', standardFirewall, standardZone);
            graph.insertEdge(parent, null, '', publicFirewall, publicZone);
            
            // Add switches behind firewalls
            const highSecuritySwitch = graph.insertVertex(parent, null, 'HS Switch', 
                150, 500, 60, 60, `${vendor}Switch`);
            
            const standardSwitch = graph.insertVertex(parent, null, 'Standard Switch', 
                350, 500, 60, 60, `${vendor}Switch`);
            
            const publicSwitch = graph.insertVertex(parent, null, 'Public Switch', 
                550, 500, 60, 60, `${vendor}Switch`);
            
            // Connect switches to firewalls
            graph.insertEdge(parent, null, '', highSecuritySwitch, highSecurityFirewall);
            graph.insertEdge(parent, null, '', standardSwitch, standardFirewall);
            graph.insertEdge(parent, null, '', publicSwitch, publicFirewall);
            
            // Add endpoint devices
            const secureWorkstation = graph.insertVertex(parent, null, 'Secure Workstation', 
                150, 600, 60, 60, 'deviceDesktop');
            
            const standardWorkstation = graph.insertVertex(parent, null, 'Standard Workstation', 
                350, 600, 60, 60, 'deviceDesktop');
            
            const publicKiosk = graph.insertVertex(parent, null, 'Public Kiosk', 
                550, 600, 60, 60, 'deviceIot');
            
            // Connect endpoints to switches
            graph.insertEdge(parent, null, '', secureWorkstation, highSecuritySwitch);
            graph.insertEdge(parent, null, '', standardWorkstation, standardSwitch);
            graph.insertEdge(parent, null, '', publicKiosk, publicSwitch);
            
            // Add authentication methods
            const certificates = graph.insertVertex(parent, null, 'Certificate', 
                50, 150, 60, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/certificates/certificate.svg;');
            
            const eapTls = graph.insertVertex(parent, null, 'EAP-TLS', 
                700, 150, 100, 60, 'authTLS');
            
            const smartCard = graph.insertVertex(parent, null, 'Smart Card', 
                700, 250, 100, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/certificates/smart_card.svg;');
            
            graph.insertEdge(parent, null, '', certificates, portnoxCloud);
            graph.insertEdge(parent, null, 'High Security Auth', eapTls, portnoxCloud);
            graph.insertEdge(parent, null, 'PIV Card Auth', smartCard, portnoxCloud);
            
            // Add compliance features box
            const complianceBox = graph.insertVertex(parent, null, 
                'Government Security Features:\n• FIPS 140-2 Compliance\n• Certificate-Based Auth\n• Smart Card / PIV Support\n• Network Segmentation\n• Continuous Monitoring\n• Comprehensive Auditing', 
                700, 350, 200, 120, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#e1d5e7;strokeColor=#9673a6;align=left;');
            
            // Center the graph
            graph.center(true, true, 0.5, 0.5);
        } finally {
            graph.getModel().endUpdate();
        }
    };
    
    // Financial services deployment
    const generateFinancialDeployment = function() {
        const parent = graph.getDefaultParent();
        
        graph.getModel().beginUpdate();
        try {
            // Add title
            const title = graph.insertVertex(parent, null, 'Portnox Cloud Financial Services Deployment', 
                350, 20, 350, 30, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=16;fontStyle=1');
            
            // Add subtitle focusing on compliance
            const subtitle = graph.insertVertex(parent, null, 'PCI-DSS and GLBA Compliant NAC Solution', 
                350, 50, 300, 20, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;');
            
            // Add Portnox Cloud
            const portnoxCloud = graph.insertVertex(parent, null, 'Portnox Cloud', 
                350, 80, 150, 60, 'portnoxCloud');
            
            // Add RADIUS Servers (Primary and Secondary for redundancy)
            const radiusPrimary = graph.insertVertex(parent, null, 'Primary RADIUS', 
                250, 180, 150, 60, 'portnoxRadius');
            
            const radiusSecondary = graph.insertVertex(parent, null, 'Secondary RADIUS', 
                450, 180, 150, 60, 'portnoxRadius');
            
            // Connect Portnox Cloud to RADIUS servers
            graph.insertEdge(parent, null, 'API', portnoxCloud, radiusPrimary);
            graph.insertEdge(parent, null, 'API', portnoxCloud, radiusSecondary);
            
            // Add Security Zones
            const cardholdersZone = graph.insertVertex(parent, null, 'Cardholder Data Zone', 
                150, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#f8cecc;strokeColor=#b85450;');
            
            const employeeZone = graph.insertVertex(parent, null, 'Employee Zone', 
                350, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#d5e8d4;strokeColor=#82b366;');
            
            const guestZone = graph.insertVertex(parent, null, 'Guest Zone', 
                550, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#dae8fc;strokeColor=#6c8ebf;');
            
            // Connect RADIUS to Zones
            graph.insertEdge(parent, null, 'RADIUS', radiusPrimary, cardholdersZone);
            graph.insertEdge(parent, null, 'RADIUS', radiusPrimary, employeeZone);
            graph.insertEdge(parent, null, 'RADIUS', radiusSecondary, employeeZone);
            graph.insertEdge(parent, null, 'RADIUS', radiusSecondary, guestZone);
            
            // Add network infrastructure
            const vendor = currentConfig.vendor || 'cisco';
            
            // Financial Institution Layout
            const bankLayout = graph.insertVertex(parent, null, 'Financial Institution', 
                350, 400, 500, 200, 'shape=rectangle;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // Payment Processing Area
            const paymentArea = graph.insertVertex(parent, null, 'Payment Processing', 
                200, 450, 100, 60, 'shape=rectangle;fillColor=#f8cecc;strokeColor=#b85450;parent=bankLayout;');
            
            // Employee Office Area
            const officeArea = graph.insertVertex(parent, null, 'Office Area', 
                350, 450, 100, 60, 'shape=rectangle;fillColor=#d5e8d4;strokeColor=#82b366;parent=bankLayout;');
            
            // Lobby/Customer Area
            const lobbyArea = graph.insertVertex(parent, null, 'Lobby/Customer Area', 
                500, 450, 100, 60, 'shape=rectangle;fillColor=#dae8fc;strokeColor=#6c8ebf;parent=bankLayout;');
            
            // Add network devices in each area
            const paymentSwitch = graph.insertVertex(parent, null, 'PCI Switch', 
                200, 520, 60, 40, `${vendor}Switch;parent=bankLayout;`);
            
            const officeSwitch = graph.insertVertex(parent, null, 'Office Switch', 
                350, 520, 60, 40, `${vendor}Switch;parent=bankLayout;`);
            
            const lobbyAP = graph.insertVertex(parent, null, 'Lobby AP', 
                500, 520, 60, 40, `${vendor}WirelessAP;parent=bankLayout;`);
            
            // Connect devices to areas
            graph.insertEdge(parent, null, '', paymentSwitch, paymentArea, 'parent=bankLayout;');
            graph.insertEdge(parent, null, '', officeSwitch, officeArea, 'parent=bankLayout;');
            graph.insertEdge(parent, null, '', lobbyAP, lobbyArea, 'parent=bankLayout;');
            
            // Connect zones to areas
            graph.insertEdge(parent, null, '', cardholdersZone, paymentSwitch);
            graph.insertEdge(parent, null, '', employeeZone, officeSwitch);
            graph.insertEdge(parent, null, '', guestZone, lobbyAP);
            
            // Add endpoint devices
            const paymentTerminal = graph.insertVertex(parent, null, 'Payment Terminal', 
                150, 650, 60, 60, 'deviceIot');
            
            const employeeLaptop = graph.insertVertex(parent, null, 'Employee Laptop', 
                350, 650, 60, 60, 'deviceDesktop');
            
            const customerDevice = graph.insertVertex(parent, null, 'Customer Device', 
                550, 650, 60, 60, 'deviceByod');
            
            // Connect endpoints to switches
            graph.insertEdge(parent, null, '', paymentTerminal, paymentSwitch);
            graph.insertEdge(parent, null, '', employeeLaptop, officeSwitch);
            graph.insertEdge(parent, null, '', customerDevice, lobbyAP);
            
            // Add authentication methods
            const eapTls = graph.insertVertex(parent, null, 'EAP-TLS', 
                700, 150, 100, 60, 'authTLS');
            
            const mab = graph.insertVertex(parent, null, 'MAB', 
                700, 250, 100, 60, 'authMAB');
            
            graph.insertEdge(parent, null, 'Employee Auth', eapTls, portnoxCloud);
            graph.insertEdge(parent, null, 'POS Auth', mab, portnoxCloud);
            
            // Add compliance features box
            const complianceBox = graph.insertVertex(parent, null, 
                'Financial Compliance Features:\n• PCI-DSS Compliance\n• GLBA Data Protection\n• Network Segmentation\n• Multi-factor Authentication\n• Continuous Compliance\n• Detailed Audit Trails', 
                700, 350, 200, 120, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#fff2cc;strokeColor=#d6b656;align=left;');
            
            // Center the graph
            graph.center(true, true, 0.5, 0.5);
        } finally {
            graph.getModel().endUpdate();
        }
    };
    
    // EAP-TLS Authentication Flow diagram
    const generateEapTlsAuthenticationFlow = function() {
        const parent = graph.getDefaultParent();
        
        graph.getModel().beginUpdate();
        try {
            // Add title
            const title = graph.insertVertex(parent, null, 'EAP-TLS Authentication Flow with Portnox Cloud', 
                400, 20, 350, 30, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=16;fontStyle=1');
            
            // Add main components - Client, Switch, RADIUS, Portnox Cloud
            const client = graph.insertVertex(parent, null, 'Client\n(Supplicant)', 
                100, 100, 120, 60, 'shape=rectangle;rounded=1;fillColor=#dae8fc;strokeColor=#6c8ebf;fontSize=12;');
            
            const nacSwitch = graph.insertVertex(parent, null, 'Switch\n(Authenticator)', 
                300, 100, 120, 60, 'shape=rectangle;rounded=1;fillColor=#d5e8d4;strokeColor=#82b366;fontSize=12;');
            
            const radiusServer = graph.insertVertex(parent, null, 'RADIUS Server', 
                500, 100, 120, 60, 'portnoxRadius;fontSize=12;');
            
            const portnoxCloud = graph.insertVertex(parent, null, 'Portnox Cloud', 
                700, 100, 120, 60, 'portnoxCloud;fontSize=12;');
            
            // Connect components
            graph.insertEdge(parent, null, 'API', portnoxCloud, radiusServer);
            
            // Add authentication flow steps
            const stepY = 200;
            const stepHeight = 40;
            const stepGap = 10;
            
            // 1. EAPOL-Start
            const step1 = graph.insertVertex(parent, null, '1. EAPOL-Start', 
                400, stepY, 200, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // Draw arrow from client to switch
            const step1Edge = graph.insertEdge(parent, null, '', client, nacSwitch, 
                'startArrow=none;endArrow=classic;dashed=0;html=1;strokeWidth=1.5;');
            
            // 2. EAP-Request Identity
            const step2 = graph.insertVertex(parent, null, '2. EAP-Request Identity', 
                400, stepY + (stepHeight + stepGap), 200, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // Draw arrow from switch to client
            const step2Edge = graph.insertEdge(parent, null, '', nacSwitch, client, 
                'startArrow=none;endArrow=classic;dashed=0;html=1;strokeWidth=1.5;');
            
            // 3. EAP-Response Identity
            const step3 = graph.insertVertex(parent, null, '3. EAP-Response Identity', 
                400, stepY + 2 * (stepHeight + stepGap), 200, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // Draw arrow from client to switch
            const step3Edge = graph.insertEdge(parent, null, '', client, nacSwitch, 
                'startArrow=none;endArrow=classic;dashed=0;html=1;strokeWidth=1.5;');
            
            // 4. RADIUS Access-Request (Identity)
            const step4 = graph.insertVertex(parent, null, '4. RADIUS Access-Request (Identity)', 
                400, stepY + 3 * (stepHeight + stepGap), 200, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // Draw arrow from switch to RADIUS
            const step4Edge = graph.insertEdge(parent, null, '', nacSwitch, radiusServer, 
                'startArrow=none;endArrow=classic;dashed=0;html=1;strokeWidth=1.5;');
            
            // 5. RADIUS Access-Challenge (TLS Start)
            const step5 = graph.insertVertex(parent, null, '5. RADIUS Access-Challenge (TLS Start)', 
                400, stepY + 4 * (stepHeight + stepGap), 200, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // Draw arrow from RADIUS to switch
            const step5Edge = graph.insertEdge(parent, null, '', radiusServer, nacSwitch, 
                'startArrow=none;endArrow=classic;dashed=0;html=1;strokeWidth=1.5;');
            
            // 6. EAP-Request (TLS Start)
            const step6 = graph.insertVertex(parent, null, '6. EAP-Request (TLS Start)', 
                400, stepY + 5 * (stepHeight + stepGap), 200, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // Draw arrow from switch to client
            const step6Edge = graph.insertEdge(parent, null, '', nacSwitch, client, 
                'startArrow=none;endArrow=classic;dashed=0;html=1;strokeWidth=1.5;');
            
            // 7. EAP-Response (Client Hello)
            const step7 = graph.insertVertex(parent, null, '7. EAP-Response (Client Hello)', 
                400, stepY + 6 * (stepHeight + stepGap), 200, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // Draw arrow from client to switch
            const step7Edge = graph.insertEdge(parent, null, '', client, nacSwitch, 
                'startArrow=none;endArrow=classic;dashed=0;html=1;strokeWidth=1.5;');
            
            // 8. RADIUS Access-Request (Client Hello)
            const step8 = graph.insertVertex(parent, null, '8. RADIUS Access-Request (Client Hello)', 
                400, stepY + 7 * (stepHeight + stepGap), 200, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // Draw arrow from switch to RADIUS
            const step8Edge = graph.insertEdge(parent, null, '', nacSwitch, radiusServer, 
                'startArrow=none;endArrow=classic;dashed=0;html=1;strokeWidth=1.5;');
            
            // 9. Certificate Validation
            const step9 = graph.insertVertex(parent, null, '9. Certificate Validation', 
                400, stepY + 8 * (stepHeight + stepGap), 200, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#ffe6cc;strokeColor=#d79b00;');
            
            // Draw arrow from RADIUS to Portnox Cloud
            const step9Edge = graph.insertEdge(parent, null, '', radiusServer, portnoxCloud, 
                'startArrow=none;endArrow=classic;dashed=0;html=1;strokeWidth=1.5;');
            
            // 10. RADIUS Access-Accept
            const step10 = graph.insertVertex(parent, null, '10. RADIUS Access-Accept', 
                400, stepY + 9 * (stepHeight + stepGap), 200, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#d5e8d4;strokeColor=#82b366;');
            
            // Draw arrow from RADIUS to switch
            const step10Edge = graph.insertEdge(parent, null, '', radiusServer, nacSwitch, 
                'startArrow=none;endArrow=classic;dashed=0;html=1;strokeWidth=1.5;');
            
            // 11. EAP-Success
            const step11 = graph.insertVertex(parent, null, '11. EAP-Success', 
                400, stepY + 10 * (stepHeight + stepGap), 200, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#d5e8d4;strokeColor=#82b366;');
            
            // Draw arrow from switch to client
            const step11Edge = graph.insertEdge(parent, null, '', nacSwitch, client, 
                'startArrow=none;endArrow=classic;dashed=0;html=1;strokeWidth=1.5;');
            
            // 12. Port Authorized
            const step12 = graph.insertVertex(parent, null, '12. Port Authorized - Full Network Access', 
                400, stepY + 11 * (stepHeight + stepGap), 200, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#d5e8d4;strokeColor=#82b366;fontStyle=1');
            
            // Add authentication states on the right
            const uncontrolledState = graph.insertVertex(parent, null, 'Port Uncontrolled State', 
                850, 250, 150, 200, 'fillColor=#f8cecc;strokeColor=#b85450;fontSize=11;');
            
            const controlledState = graph.insertVertex(parent, null, 'Port Controlled State', 
                850, 500, 150, 120, 'fillColor=#d5e8d4;strokeColor=#82b366;fontSize=11;');
            
            // Add notes about certificates
            const certificateNote = graph.insertVertex(parent, null, 
                'Certificate Validation:\n- Client presents certificate\n- RADIUS validates with Portnox\n- Portnox checks certificate\n  against trusted CAs\n- Validates revocation status', 
                850, 650, 200, 100, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#fff2cc;strokeColor=#d6b656;fontSize=10;align=left;');
            
            // Center the graph
            graph.center(true, true, 0.5, 0.5);
        } finally {
            graph.getModel().endUpdate();
        }
    };
    
    // BYOD Onboarding Flow
    const generateByodOnboardingFlow = function() {
        const parent = graph.getDefaultParent();
        
        graph.getModel().beginUpdate();
        try {
            // Add title
            const title = graph.insertVertex(parent, null, 'BYOD Onboarding Flow with Portnox Cloud', 
                400, 20, 350, 30, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=16;fontStyle=1');
            
            // Add main components
            const userDevice = graph.insertVertex(parent, null, 'User Device', 
                100, 100, 100, 60, 'deviceByod');
            
            const portnoxCloud = graph.insertVertex(parent, null, 'Portnox Cloud', 
                350, 100, 150, 60, 'portnoxCloud');
            
            const captivePortal = graph.insertVertex(parent, null, 'Captive Portal', 
                600, 100, 150, 60, 'shape=rectangle;rounded=1;fillColor=#dae8fc;strokeColor=#6c8ebf;');
            
            const ca = graph.insertVertex(parent, null, 'Certificate Authority', 
                600, 200, 60, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/certificates/ca.svg;');
            
            // Connect main components
            graph.insertEdge(parent, null, '', portnoxCloud, captivePortal);
            graph.insertEdge(parent, null, '', portnoxCloud, ca);
            
            // Add network zones on the left
            const guestVLAN = graph.insertVertex(parent, null, 'Guest VLAN', 
                100, 250, 120, 80, 'fillColor=#fff2cc;strokeColor=#d6b656;');
            
            const corporateVLAN = graph.insertVertex(parent, null, 'Corporate VLAN', 
                100, 450, 120, 80, 'fillColor=#d5e8d4;strokeColor=#82b366;');
            
            // Add onboarding flow steps
            const stepY = 250;
            const stepHeight = 40;
            const stepGap = 15;
            
            // 1. Connect to network
            const step1 = graph.insertVertex(parent, null, '1. Device connects to network', 
                400, stepY, 250, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // Draw arrow from user device to step 1
            const step1Edge = graph.insertEdge(parent, null, '', userDevice, step1);
            
            // 2. Redirect to portal
            const step2 = graph.insertVertex(parent, null, '2. Redirect to captive portal', 
                400, stepY + (stepHeight + stepGap), 250, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // Draw arrow from step 1 to step 2
            const step2Edge = graph.insertEdge(parent, null, '', step1, step2);
            
            // 3. User authentication
            const step3 = graph.insertVertex(parent, null, '3. User logs in with corporate credentials', 
                400, stepY + 2 * (stepHeight + stepGap), 250, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // Draw arrow from step 2 to step 3
            const step3Edge = graph.insertEdge(parent, null, '', step2, step3);
            
            // 4. Device assessment
            const step4 = graph.insertVertex(parent, null, '4. Portnox performs device assessment', 
                400, stepY + 3 * (stepHeight + stepGap), 250, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // Draw arrow from step 3 to step 4
            const step4Edge = graph.insertEdge(parent, null, '', step3, step4);
            
            // 5. Certificate generation
            const step5 = graph.insertVertex(parent, null, '5. Certificate generation for device', 
                400, stepY + 4 * (stepHeight + stepGap), 250, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#ffe6cc;strokeColor=#d79b00;');
            
            // Draw arrow from step 4 to step 5
            const step5Edge = graph.insertEdge(parent, null, '', step4, step5);
            
            // Connect step 5 to CA
            const step5ToCA = graph.insertEdge(parent, null, 'Request cert', step5, ca);
            
            // 6. Profile installation
            const step6 = graph.insertVertex(parent, null, '6. User installs configuration profile', 
                400, stepY + 5 * (stepHeight + stepGap), 250, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // Draw arrow from step 5 to step 6
            const step6Edge = graph.insertEdge(parent, null, '', step5, step6);
            
            // 7. Device reauthenticates
            const step7 = graph.insertVertex(parent, null, '7. Device reconnects with EAP-TLS', 
                400, stepY + 6 * (stepHeight + stepGap), 250, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#d5e8d4;strokeColor=#82b366;');
            
            // Draw arrow from step 6 to step 7
            const step7Edge = graph.insertEdge(parent, null, '', step6, step7);
            
            // 8. Full access granted
            const step8 = graph.insertVertex(parent, null, '8. Full corporate access granted', 
                400, stepY + 7 * (stepHeight + stepGap), 250, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#d5e8d4;strokeColor=#82b366;fontStyle=1');
            
            // Draw arrow from step 7 to step 8
            const step8Edge = graph.insertEdge(parent, null, '', step7, step8);
            
            // Connect flow to VLANs
            const flowToGuestVLAN = graph.insertEdge(parent, null, 'Initial Connection', step1, guestVLAN, 'dashed=1;');
            const flowToCorporateVLAN = graph.insertEdge(parent, null, 'After Onboarding', step8, corporateVLAN, 'dashed=1;');
            
            // Add notes about onboarding
            const onboardingNote = graph.insertVertex(parent, null, 
                'BYOD Onboarding Benefits:\n- Secure device authentication\n- User-friendly self-service\n- Certificate-based security\n- Automatic VLAN assignment\n- Compliance validation', 
                700, 400, 200, 100, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#e1d5e7;strokeColor=#9673a6;align=left;');
            
            // Center the graph
            graph.center(true, true, 0.5, 0.5);
        } finally {
            graph.getModel().endUpdate();
        }
    };
    
    // Dynamic VLAN Assignment diagram
    const generateDynamicVlanAssignment = function() {
        const parent = graph.getDefaultParent();
        
        graph.getModel().beginUpdate();
        try {
            // Add title
            const title = graph.insertVertex(parent, null, 'Dynamic VLAN Assignment with Portnox Cloud', 
                400, 20, 350, 30, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=16;fontStyle=1');
            
            // Add Portnox Cloud
            const portnoxCloud = graph.insertVertex(parent, null, 'Portnox Cloud', 
                400, 80, 150, 60, 'portnoxCloud');
            
            // Add RADIUS Server
            const radiusServer = graph.insertVertex(parent, null, 'Portnox RADIUS', 
                400, 180, 150, 60, 'portnoxRadius');
            
            // Connect Portnox Cloud to RADIUS
            graph.insertEdge(parent, null, 'API', portnoxCloud, radiusServer);
            
            // Add network components
            const vendor = currentConfig.vendor || 'cisco';
            const networkSwitch = graph.insertVertex(parent, null, 'Network Switch', 
                400, 300, 60, 60, `${vendor}Switch`);
            
            // Connect RADIUS to switch
            graph.insertEdge(parent, null, 'RADIUS', radiusServer, networkSwitch);
            
            // Add different device types
            const devices = [
                { name: 'Corporate Laptop', image: 'deviceDesktop', x: 200, y: 400, 
                  vlan: 'VLAN 10 - Corporate', vlanColor: '#d5e8d4', vlanStroke: '#82b366', attributes: 'User Group, Device Type' },
                { name: 'BYOD Device', image: 'deviceByod', x: 400, y: 400, 
                  vlan: 'VLAN 20 - BYOD', vlanColor: '#dae8fc', vlanStroke: '#6c8ebf', attributes: 'User Group, Device Posture' },
                { name: 'IoT Device', image: 'deviceIot', x: 600, y: 400, 
                  vlan: 'VLAN 30 - IoT', vlanColor: '#ffe6cc', vlanStroke: '#d79b00', attributes: 'Device Type, MAC OUI' }
            ];
            
            // Add devices and VLANs
            devices.forEach(device => {
                // Add device
                const deviceVertex = graph.insertVertex(parent, null, device.name, 
                    device.x, device.y, 60, 60, device.image);
                
                // Connect device to switch
                graph.insertEdge(parent, null, '', deviceVertex, networkSwitch);
                
                // Add VLAN for the device
                const vlanVertex = graph.insertVertex(parent, null, device.vlan, 
                    device.x - 50, device.y + 100, 160, 40, `shape=rectangle;rounded=1;fillColor=${device.vlanColor};strokeColor=${device.vlanStroke};`);
                
                // Connect device to VLAN
                graph.insertEdge(parent, null, device.attributes, deviceVertex, vlanVertex, 'dashed=1;endArrow=classic;');
            });
            
            // Add RADIUS attributes box
            const attributesBox = graph.insertVertex(parent, null, 
                'RADIUS Attributes:\n- Tunnel-Type (13)\n- Tunnel-Medium-Type (6)\n- Tunnel-Private-Group-ID (VLAN)', 
                600, 180, 200, 60, 'fillColor=#ffe6cc;strokeColor=#d79b00;align=left;');
            
            // Connect RADIUS to attributes
            graph.insertEdge(parent, null, '', radiusServer, attributesBox, 'dashed=1;');
            
            // Add detailed explanation
            const explanationBox = graph.insertVertex(parent, null, 
                'Dynamic VLAN Assignment:\n\n1. Device authenticates to the network\n2. Portnox evaluates device & user attributes\n3. Portnox determines appropriate VLAN\n4. RADIUS returns VLAN attributes\n5. Switch places device in assigned VLAN', 
                150, 180, 200, 100, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#f5f5f5;strokeColor=#666666;align=left;');
            
            // Add benefits/use cases box
            const benefitsBox = graph.insertVertex(parent, null, 
                'Use Cases:\n• Device-based segmentation\n• User role-based access\n• Compliance-based access\n• Guest isolation\n• IoT segmentation\n• Dynamic security isolation', 
                700, 350, 160, 120, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#e1d5e7;strokeColor=#9673a6;align=left;');
            
            // Center the graph
            graph.center(true, true, 0.5, 0.5);
        } finally {
            graph.getModel().endUpdate();
        }
    };
    
    // Multi-vendor deployment diagram
    const generateMultiVendorDeployment = function() {
        const parent = graph.getDefaultParent();
        
        graph.getModel().beginUpdate();
        try {
            // Add title
            const title = graph.insertVertex(parent, null, 'Multi-Vendor Deployment with Portnox Cloud', 
                400, 20, 350, 30, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=16;fontStyle=1');
            
            // Add Portnox Cloud
            const portnoxCloud = graph.insertVertex(parent, null, 'Portnox Cloud', 
                400, 80, 150, 60, 'portnoxCloud');
            
            // Add RADIUS Server
            const radiusServer = graph.insertVertex(parent, null, 'Portnox RADIUS', 
                400, 180, 150, 60, 'portnoxRadius');
            
            // Connect Portnox Cloud to RADIUS
            graph.insertEdge(parent, null, 'API', portnoxCloud, radiusServer);
            
            // Add network zones
            const hqNetwork = graph.insertVertex(parent, null, 'Headquarters', 
                200, 300, 120, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#d5e8d4;strokeColor=#82b366;');
            
            const branchNetwork = graph.insertVertex(parent, null, 'Branch Office', 
                400, 300, 120, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#dae8fc;strokeColor=#6c8ebf;');
            
            const datacenterNetwork = graph.insertVertex(parent, null, 'Data Center', 
                600, 300, 120, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#ffe6cc;strokeColor=#d79b00;');
            
            // Connect RADIUS to Network zones
            graph.insertEdge(parent, null, 'RADIUS', radiusServer, hqNetwork);
            graph.insertEdge(parent, null, 'RADIUS', radiusServer, branchNetwork);
            graph.insertEdge(parent, null, 'RADIUS', radiusServer, datacenterNetwork);
            
            // Add different vendor equipment in each zone
            
            // Headquarters - Cisco equipment
            const ciscoSwitch = graph.insertVertex(parent, null, 'Cisco Switch', 
                150, 400, 60, 60, 'ciscoSwitch');
            
            const ciscoWLC = graph.insertVertex(parent, null, 'Cisco WLC', 
                250, 400, 60, 60, 'ciscoWirelessAP');
            
            // Connect Cisco equipment to HQ
            graph.insertEdge(parent, null, '', ciscoSwitch, hqNetwork);
            graph.insertEdge(parent, null, '', ciscoWLC, hqNetwork);
            
            // Branch - Aruba equipment
            const arubaSwitch = graph.insertVertex(parent, null, 'Aruba Switch', 
                350, 400, 60, 60, 'arubaSwitch');
            
            const arubaAP = graph.insertVertex(parent, null, 'Aruba AP', 
                450, 400, 60, 60, 'arubaWirelessAP');
            
            // Connect Aruba equipment to Branch
            graph.insertEdge(parent, null, '', arubaSwitch, branchNetwork);
            graph.insertEdge(parent, null, '', arubaAP, branchNetwork);
            
            // Data Center - Juniper equipment
            const juniperSwitch = graph.insertVertex(parent, null, 'Juniper Switch', 
                550, 400, 60, 60, 'juniperSwitch');
            
            const paloAltoFW = graph.insertVertex(parent, null, 'Palo Alto FW', 
                650, 400, 60, 60, 'paloaltoFirewall');
            
            // Connect Juniper equipment to Data Center
            graph.insertEdge(parent, null, '', juniperSwitch, datacenterNetwork);
            graph.insertEdge(parent, null, '', paloAltoFW, datacenterNetwork);
            
            // Add endpoints
            const ciscoPhone = graph.insertVertex(parent, null, 'IP Phone', 
                150, 500, 60, 60, 'devicePhone');
            
            const workstation = graph.insertVertex(parent, null, 'Workstation', 
                250, 500, 60, 60, 'deviceDesktop');
            
            const laptop = graph.insertVertex(parent, null, 'Laptop', 
                350, 500, 60, 60, 'deviceByod');
            
            const mobileDevice = graph.insertVertex(parent, null, 'Mobile Device', 
                450, 500, 60, 60, 'deviceByod');
            
            const server = graph.insertVertex(parent, null, 'Server', 
                550, 500, 60, 60, 'deviceServer');
            
            const storageArray = graph.insertVertex(parent, null, 'Storage Array', 
                650, 500, 60, 60, 'deviceIot');
            
            // Connect endpoints to switches/APs
            graph.insertEdge(parent, null, '', ciscoPhone, ciscoSwitch);
            graph.insertEdge(parent, null, '', workstation, ciscoSwitch);
            graph.insertEdge(parent, null, '', laptop, ciscoWLC);
            graph.insertEdge(parent, null, '', mobileDevice, arubaAP);
            graph.insertEdge(parent, null, '', server, juniperSwitch);
            graph.insertEdge(parent, null, '', storageArray, juniperSwitch);
            
            // Add multi-vendor support information
            const vendorSupportBox = graph.insertVertex(parent, null, 
                'Multi-Vendor Support:\n• Vendor-specific attributes (VSAs)\n• Standardized RADIUS attributes\n• Customizable authentication policies\n• Unified reporting & management\n• Consistent user experience', 
                700, 250, 200, 100, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#f5f5f5;strokeColor=#666666;align=left;');
            
            // Add vendor logos/icons
            const vendorLogos = graph.insertVertex(parent, null, '', 
                700, 100, 140, 100, 'shape=rectangle;fillColor=none;strokeColor=none;align=center;', 'container=1');
            
            const ciscoLogo = graph.insertVertex(vendorLogos, null, 'Cisco', 
                700, 100, 40, 40, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/vendors/cisco/logo.svg;');
            
            const arubaLogo = graph.insertVertex(vendorLogos, null, 'Aruba', 
                750, 100, 40, 40, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/vendors/aruba/logo.svg;');
            
            const juniperLogo = graph.insertVertex(vendorLogos, null, 'Juniper', 
                800, 100, 40, 40, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/vendors/juniper/logo.svg;');
            
            const extremeLogo = graph.insertVertex(vendorLogos, null, 'Extreme', 
                700, 160, 40, 40, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/vendors/extreme/logo.svg;');
            
            const paloaltoLogo = graph.insertVertex(vendorLogos, null, 'Palo Alto', 
                750, 160, 40, 40, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/vendors/paloalto/logo.svg;');
            
            const fortinetLogo = graph.insertVertex(vendorLogos, null, 'Fortinet', 
                800, 160, 40, 40, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/vendors/fortinet/logo.svg;');
            
            // Connect logos to Portnox
            graph.insertEdge(parent, null, '', portnoxCloud, vendorLogos, 'dashed=1;endArrow=none;startArrow=none;');
            
            // Add Vendor-Agnostic NAC title
            const nacTitle = graph.insertVertex(parent, null, 'Vendor-Agnostic NAC', 
                770, 60, 140, 30, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontStyle=1');
            
            // Center the graph
            graph.center(true, true, 0.5, 0.5);
        } finally {
            graph.getModel().endUpdate();
        }
    };
    
    // High security deployment diagram
    const generateHighSecurityDeployment = function() {
        const parent = graph.getDefaultParent();
        
        graph.getModel().beginUpdate();
        try {
            // Add title
            const title = graph.insertVertex(parent, null, 'High Security Portnox Cloud Deployment', 
                400, 20, 350, 30, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=16;fontStyle=1');
            
            // Add Portnox Cloud
            const portnoxCloud = graph.insertVertex(parent, null, 'Portnox Cloud', 
                400, 80, 150, 60, 'portnoxCloud');
            
            // Add Azure AD / Identity integration
            const azureAD = graph.insertVertex(parent, null, 'Azure AD', 
                600, 80, 60, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/cloud/azure/active_directory.svg;');
            
            // Connect Portnox to Azure AD
            graph.insertEdge(parent, null, 'Identity', azureAD, portnoxCloud);
            
            // Add MFA service
            const mfaService = graph.insertVertex(parent, null, 'MFA Service', 
                200, 80, 60, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/security/mfa.svg;');
            
            // Connect Portnox to MFA
            graph.insertEdge(parent, null, '2FA', mfaService, portnoxCloud);
            
            // Add RADIUS Servers
            const radiusPrimary = graph.insertVertex(parent, null, 'Primary RADIUS', 
                300, 180, 150, 60, 'portnoxRadius');
            
            const radiusSecondary = graph.insertVertex(parent, null, 'Secondary RADIUS', 
                500, 180, 150, 60, 'portnoxRadius');
            
            // Connect Portnox to RADIUS servers
            graph.insertEdge(parent, null, 'API', portnoxCloud, radiusPrimary);
            graph.insertEdge(parent, null, 'API', portnoxCloud, radiusSecondary);
            
            // Add Certificate Authority
            const ca = graph.insertVertex(parent, null, 'Certificate Authority', 
                700, 180, 60, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/certificates/ca.svg;');
            
            // Connect CA to Portnox
            graph.insertEdge(parent, null, 'Certificate Management', ca, portnoxCloud, 'dashed=1;');
            
            // Add security zones
            const restrictedZone = graph.insertVertex(parent, null, 'Restricted Zone', 
                200, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#f8cecc;strokeColor=#b85450;');
            
            const secureZone = graph.insertVertex(parent, null, 'Secure Zone', 
                400, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#d5e8d4;strokeColor=#82b366;');
            
            const standardZone = graph.insertVertex(parent, null, 'Standard Zone', 
                600, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#dae8fc;strokeColor=#6c8ebf;');
            
            // Connect RADIUS to zones
            graph.insertEdge(parent, null, 'RADIUS', radiusPrimary, restrictedZone);
            graph.insertEdge(parent, null, 'RADIUS', radiusPrimary, secureZone);
            graph.insertEdge(parent, null, 'RADIUS', radiusSecondary, secureZone);
            graph.insertEdge(parent, null, 'RADIUS', radiusSecondary, standardZone);
            
            // Add network components
            const vendor = currentConfig.vendor || 'cisco';
            
            // Add firewalls in each zone
            const restrictedFirewall = graph.insertVertex(parent, null, 'Restricted Firewall', 
                200, 400, 60, 60, `${vendor}Firewall`);
            
            const secureFirewall = graph.insertVertex(parent, null, 'Secure Firewall', 
                400, 400, 60, 60, `${vendor}Firewall`);
            
            const standardFirewall = graph.insertVertex(parent, null, 'Standard Firewall', 
                600, 400, 60, 60, `${vendor}Firewall`);
            
            // Connect firewalls to zones
            graph.insertEdge(parent, null, '', restrictedFirewall, restrictedZone);
            graph.insertEdge(parent, null, '', secureFirewall, secureZone);
            graph.insertEdge(parent, null, '', standardFirewall, standardZone);
            
            // Add switches behind firewalls
            const restrictedSwitch = graph.insertVertex(parent, null, 'Restricted Switch', 
                200, 500, 60, 60, `${vendor}Switch`);
            
            const secureSwitch = graph.insertVertex(parent, null, 'Secure Switch', 
                400, 500, 60, 60, `${vendor}Switch`);
            
            const standardSwitch = graph.insertVertex(parent, null, 'Standard Switch', 
                600, 500, 60, 60, `${vendor}Switch`);
            
            // Connect switches to firewalls
            graph.insertEdge(parent, null, '', restrictedSwitch, restrictedFirewall);
            graph.insertEdge(parent, null, '', secureSwitch, secureFirewall);
            graph.insertEdge(parent, null, '', standardSwitch, standardFirewall);
            
            // Add endpoints
            const restrictedWorkstation = graph.insertVertex(parent, null, 'High Security\nWorkstation', 
                200, 600, 60, 60, 'deviceDesktop');
            
            const secureWorkstation = graph.insertVertex(parent, null, 'Secure Workstation', 
                400, 600, 60, 60, 'deviceDesktop');
            
            const standardWorkstation = graph.insertVertex(parent, null, 'Standard Device', 
                600, 600, 60, 60, 'deviceByod');
            
            // Connect endpoints to switches
            graph.insertEdge(parent, null, '', restrictedWorkstation, restrictedSwitch);
            graph.insertEdge(parent, null, '', secureWorkstation, secureSwitch);
            graph.insertEdge(parent, null, '', standardWorkstation, standardSwitch);
            
            // Add authentication methods by zone
            // High Security
            const highSecAuth = graph.insertVertex(parent, null, 
                'Restricted Zone Security:\n• EAP-TLS with hardware tokens\n• Smart Card / PIV cards\n• Posture assessment\n• Continuous monitoring', 
                50, 400, 130, 80, 'shape=document;whiteSpace=wrap;html=1;boundedLbl=1;fillColor=#f8cecc;strokeColor=#b85450;align=left;fontSize=10;');
            
            // Secure
            const secureAuth = graph.insertVertex(parent, null, 
                'Secure Zone Security:\n• EAP-TLS with certificates\n• MFA when required\n• Device compliance\n• Remediation capabilities', 
                800, 400, 130, 80, 'shape=document;whiteSpace=wrap;html=1;boundedLbl=1;fillColor=#d5e8d4;strokeColor=#82b366;align=left;fontSize=10;');
            
            // Standard
            const standardAuth = graph.insertVertex(parent, null, 
                'Standard Zone Security:\n• Multiple auth methods\n• Web authentication\n• BYOD onboarding\n• Basic posture checks', 
                800, 500, 130, 80, 'shape=document;whiteSpace=wrap;html=1;boundedLbl=1;fillColor=#dae8fc;strokeColor=#6c8ebf;align=left;fontSize=10;');
            
            // Add security components box
            const securityBox = graph.insertVertex(parent, null, 
                'Security Components:\n• Certificate-based authentication\n• Multi-factor authentication\n• Zero Trust architecture\n• Micro-segmentation\n• Continuous compliance monitoring\n• Automated threat response', 
                50, 500, 130, 100, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#fff2cc;strokeColor=#d6b656;align=left;fontSize=10;');
            
            // Center the graph
            graph.center(true, true, 0.5, 0.5);
        } finally {
            graph.getModel().endUpdate();
        }
    };
    
    // Portnox Cloud integration with other cloud services
    const generateCloudIntegration = function() {
        const parent = graph.getDefaultParent();
        
        graph.getModel().beginUpdate();
        try {
            // Add title
            const title = graph.insertVertex(parent, null, 'Portnox Cloud Integration with Cloud Services', 
                400, 20, 350, 30, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=16;fontStyle=1');
            
            // Add Portnox Cloud in center
            const portnoxCloud = graph.insertVertex(parent, null, 'Portnox Cloud', 
                400, 300, 150, 60, 'portnoxCloud');
            
            // Add Identity Providers (top)
            const azureAD = graph.insertVertex(parent, null, 'Azure AD', 
                300, 150, 60, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/cloud/azure/active_directory.svg;');
            
            const googleWorkspace = graph.insertVertex(parent, null, 'Google Workspace', 
                400, 150, 60, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/idp/google/workspace.svg;');
            
            const okta = graph.insertVertex(parent, null, 'Okta', 
                500, 150, 60, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/idp/okta/okta.svg;');
            
            // Connect Identity Providers to Portnox
            graph.insertEdge(parent, null, 'SAML/OIDC', azureAD, portnoxCloud);
            graph.insertEdge(parent, null, 'SAML/OIDC', googleWorkspace, portnoxCloud);
            graph.insertEdge(parent, null, 'SAML/OIDC', okta, portnoxCloud);
            
            // Add device management (right)
            const intune = graph.insertVertex(parent, null, 'Microsoft Intune', 
                600, 250, 60, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/mdm/intune/intune.svg;');
            
            const jamf = graph.insertVertex(parent, null, 'Jamf', 
                600, 350, 60, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/mdm/jamf/jamf.svg;');
            
            // Connect MDM solutions to Portnox
            graph.insertEdge(parent, null, 'Device Compliance', intune, portnoxCloud);
            graph.insertEdge(parent, null, 'Device Compliance', jamf, portnoxCloud);
            
            // Add SIEM/Security tools (bottom)
            const splunk = graph.insertVertex(parent, null, 'Splunk', 
                300, 450, 60, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/security/splunk.svg;');
            
            const sentinel = graph.insertVertex(parent, null, 'MS Sentinel', 
                500, 450, 60, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/security/sentinel.svg;');
            
            // Connect SIEM to Portnox
            graph.insertEdge(parent, null, 'Logs & Events', portnoxCloud, splunk);
            graph.insertEdge(parent, null, 'Security Events', portnoxCloud, sentinel);
            
            // Add ITSM/Ticketing (left)
            const serviceNow = graph.insertVertex(parent, null, 'ServiceNow', 
                200, 250, 60, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/services/servicenow.svg;');
            
            const jira = graph.insertVertex(parent, null, 'Jira', 
                200, 350, 60, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/services/jira.svg;');
            
            // Connect ITSM to Portnox
            graph.insertEdge(parent, null, 'Ticketing', serviceNow, portnoxCloud);
            graph.insertEdge(parent, null, 'Issue Tracking', jira, portnoxCloud);
            
            // Add on-premises components
            const radius = graph.insertVertex(parent, null, 'RADIUS', 
                400, 550, 150, 60, 'portnoxRadius');
            
            // Connect Portnox to RADIUS
            graph.insertEdge(parent, null, 'API', portnoxCloud, radius);
            
            // Add network infrastructure
            const vendor = currentConfig.vendor || 'cisco';
            const switch1 = graph.insertVertex(parent, null, 'Switch', 
                300, 650, 60, 60, `${vendor}Switch`);
            
            const wireless = graph.insertVertex(parent, null, 'Wireless', 
                500, 650, 60, 60, `${vendor}WirelessAP`);
            
            // Connect network components to RADIUS
            graph.insertEdge(parent, null, 'RADIUS', radius, switch1);
            graph.insertEdge(parent, null, 'RADIUS', radius, wireless);
            
            // Add Cloud Integration benefits panel
            const benefitsBox = graph.insertVertex(parent, null, 
                'Cloud Integration Benefits:\n• Single sign-on (SSO)\n• Automated user provisioning\n• Device compliance checking\n• Automated incident response\n• Centralized reporting\n• API-driven workflows', 
                700, 300, 170, 120, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#e1d5e7;strokeColor=#9673a6;align=left;');
            
            // Add Integration Types panel
            const integrationTypes = graph.insertVertex(parent, null, 
                'Integration Types:\n• REST APIs\n• SAML/OIDC\n• SCIM\n• Webhooks\n• RADIUS\n• Syslog/CEF', 
                100, 150, 150, 100, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#dae8fc;strokeColor=#6c8ebf;align=left;');
            
            // Center the graph
            graph.center(true, true, 0.5, 0.5);
        } finally {
            graph.getModel().endUpdate();
        }
    };
    
    // Multi-site deployment diagram
    const generateMultiSiteDeployment = function() {
        const parent = graph.getDefaultParent();
        
        graph.getModel().beginUpdate();
        try {
            // Add title
            const title = graph.insertVertex(parent, null, 'Multi-Site Portnox Cloud Deployment', 
                400, 20, 350, 30, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=16;fontStyle=1');
            
            // Add Portnox Cloud
            const portnoxCloud = graph.insertVertex(parent, null, 'Portnox Cloud', 
                400, 100, 150, 60, 'portnoxCloud');
            
            // Add Identity provider
            const identityProvider = graph.insertVertex(parent, null, 'Identity Provider', 
                600, 100, 60, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/cloud/azure/active_directory.svg;');
            
            // Connect Identity Provider to Portnox
            graph.insertEdge(parent, null, 'Identity', identityProvider, portnoxCloud);
            
            // Add Internet cloud
            const internet = graph.insertVertex(parent, null, 'Internet', 
                400, 200, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // Connect Portnox to Internet
            graph.insertEdge(parent, null, '', portnoxCloud, internet);
            
            // Add sites with different layouts
            
            // Headquarters container
            const hqSite = graph.insertVertex(parent, null, 'Headquarters', 
                150, 300, 200, 250, 'shape=rectangle;fillColor=#dae8fc;strokeColor=#6c8ebf;verticalAlign=top;fontStyle=1;fontSize=12;');
            
            // HQ RADIUS server
            const hqRadius = graph.insertVertex(parent, null, 'Primary RADIUS', 
                150, 330, 100, 40, 'portnoxRadius;fontSize=10;');
            
            // HQ Backup RADIUS
            const hqRadiusBackup = graph.insertVertex(parent, null, 'Backup RADIUS', 
                250, 330, 100, 40, 'portnoxRadius;fontSize=10;');
            
            // HQ Network devices
            const vendor = currentConfig.vendor || 'cisco';
            const hqCore = graph.insertVertex(parent, null, 'Core Switch', 
                200, 400, 50, 50, `${vendor}Switch;fontSize=10;`);
            
            const hqAccess = graph.insertVertex(parent, null, 'Access', 
                150, 470, 40, 40, `${vendor}Switch;fontSize=9;`);
            
            const hqWireless = graph.insertVertex(parent, null, 'WiFi', 
                250, 470, 40, 40, `${vendor}WirelessAP;fontSize=9;`);
            
            // Connect HQ components
            graph.insertEdge(parent, null, '', internet, hqRadius);
            graph.insertEdge(parent, null, '', internet, hqRadiusBackup);
            graph.insertEdge(parent, null, '', hqRadius, hqCore);
            graph.insertEdge(parent, null, '', hqRadiusBackup, hqCore);
            graph.insertEdge(parent, null, '', hqCore, hqAccess);
            graph.insertEdge(parent, null, '', hqCore, hqWireless);
            
            // Branch Office 1 container
            const branch1Site = graph.insertVertex(parent, null, 'Branch Office 1', 
                400, 300, 150, 200, 'shape=rectangle;fillColor=#d5e8d4;strokeColor=#82b366;verticalAlign=top;fontStyle=1;fontSize=12;');
            
            // Branch 1 RADIUS server
            const branch1Radius = graph.insertVertex(parent, null, 'RADIUS', 
                425, 330, 100, 40, 'portnoxRadius;fontSize=10;');
            
            // Branch 1 Network devices
            const branch1Switch = graph.insertVertex(parent, null, 'Switch', 
                425, 400, 50, 50, `${vendor}Switch;fontSize=10;`);
            
            const branch1Wireless = graph.insertVertex(parent, null, 'WiFi', 
                475, 400, 40, 40, `${vendor}WirelessAP;fontSize=9;`);
            
            // Connect Branch 1 components
            graph.insertEdge(parent, null, '', internet, branch1Radius);
            graph.insertEdge(parent, null, '', branch1Radius, branch1Switch);
            graph.insertEdge(parent, null, '', branch1Radius, branch1Wireless);
            
            // Branch Office 2 container
            const branch2Site = graph.insertVertex(parent, null, 'Branch Office 2', 
                600, 300, 150, 200, 'shape=rectangle;fillColor=#ffe6cc;strokeColor=#d79b00;verticalAlign=top;fontStyle=1;fontSize=12;');
            
            // Branch 2 RADIUS server
            const branch2Radius = graph.insertVertex(parent, null, 'RADIUS', 
                625, 330, 100, 40, 'portnoxRadius;fontSize=10;');
            
            // Branch 2 Network devices - different vendor
            const branch2Switch = graph.insertVertex(parent, null, 'Switch', 
                625, 400, 50, 50, 'arubaSwitch;fontSize=10;');
            
            const branch2Wireless = graph.insertVertex(parent, null, 'WiFi', 
                675, 400, 40, 40, 'arubaWirelessAP;fontSize=9;');
            
            // Connect Branch 2 components
            graph.insertEdge(parent, null, '', internet, branch2Radius);
            graph.insertEdge(parent, null, '', branch2Radius, branch2Switch);
            graph.insertEdge(parent, null, '', branch2Radius, branch2Wireless);
            
            // Remote Site container
            const remoteSite = graph.insertVertex(parent, null, 'Remote Site / Work From Home', 
                400, 550, 150, 150, 'shape=rectangle;fillColor=#e1d5e7;strokeColor=#9673a6;verticalAlign=top;fontStyle=1;fontSize=12;');
            
            // Remote devices 
            const remoteRouter = graph.insertVertex(parent, null, 'Router', 
                425, 600, 40, 40, `${vendor}Router;fontSize=9;`);
            
            const remoteLaptop = graph.insertVertex(parent, null, 'Laptop', 
                475, 600, 40, 40, 'deviceByod;fontSize=9;');
            
            // Connect Remote components
            graph.insertEdge(parent, null, '', internet, remoteRouter);
            graph.insertEdge(parent, null, '', remoteRouter, remoteLaptop);
            
            // Add multi-site management box
            const managementBox = graph.insertVertex(parent, null, 
                'Multi-Site Management Features:\n• Centralized policy management\n• Global visibility and reporting\n• Site-specific policies\n• Redundant RADIUS servers\n• Automatic failover\n• VPN integration\n• Offline authentication', 
                800, 200, 170, 140, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#f5f5f5;strokeColor=#666666;align=left;fontSize=10;');
            
            // Add Global Policy box
            const policyBox = graph.insertVertex(parent, null, 
                'Global Policy Engine', 
                200, 100, 120, 40, 'shape=cylinder;whiteSpace=wrap;html=1;boundedLbl=1;fillColor=#f8cecc;strokeColor=#b85450;');
            
            // Connect Policy to Portnox
            graph.insertEdge(parent, null, '', policyBox, portnoxCloud);
            
            // Center the graph
            graph.center(true, true, 0.5, 0.5);
        } finally {
            graph.getModel().endUpdate();
        }
    };
    
    // IoT Segmentation diagram
    const generateIoTSegmentation = function() {
        const parent = graph.getDefaultParent();
        
        graph.getModel().beginUpdate();
        try {
            // Add title
            const title = graph.insertVertex(parent, null, 'IoT Segmentation with Portnox Cloud', 
                400, 20, 350, 30, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=16;fontStyle=1');
            
            // Add Portnox Cloud
            const portnoxCloud = graph.insertVertex(parent, null, 'Portnox Cloud', 
                400, 80, 150, 60, 'portnoxCloud');
            
            // Add RADIUS Server
            const radiusServer = graph.insertVertex(parent, null, 'Portnox RADIUS', 
                400, 180, 150, 60, 'portnoxRadius');
            
            // Connect Portnox Cloud to RADIUS
            graph.insertEdge(parent, null, 'API', portnoxCloud, radiusServer);
            
            // Add Core Network
            const coreNetwork = graph.insertVertex(parent, null, 'Core Network', 
                400, 280, 120, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // Connect RADIUS to Core Network
            graph.insertEdge(parent, null, 'RADIUS', radiusServer, coreNetwork);
            
            // Add network infrastructure
            const vendor = currentConfig.vendor || 'cisco';
            const coreSwitch = graph.insertVertex(parent, null, 'Core Switch', 
                400, 380, 60, 60, `${vendor}Switch`);
            
            // Connect core switch to core network
            graph.insertEdge(parent, null, '', coreSwitch, coreNetwork);
            
            // Add IoT segments/VLANs
            const segments = [
                { name: 'Medical Devices', color: '#f8cecc', stroke: '#b85450', x: 200, devices: ['Heart Monitor', 'Infusion Pump', 'X-Ray Machine'] },
                { name: 'Building Systems', color: '#d5e8d4', stroke: '#82b366', x: 400, devices: ['HVAC Controller', 'Access Control', 'Elevator System'] },
                { name: 'Video & Voice', color: '#dae8fc', stroke: '#6c8ebf', x: 600, devices: ['IP Camera', 'Video Recorder', 'IP Phone'] }
            ];
            
            // Add each segment with devices
            segments.forEach(segment => {
                // Add segment VLAN
                const segmentVLAN = graph.insertVertex(parent, null, `${segment.name} VLAN`, 
                    segment.x, 450, 120, 40, `fillColor=${segment.color};strokeColor=${segment.stroke};rounded=1;`);
                
                // Add segment switch
                const segmentSwitch = graph.insertVertex(parent, null, `${segment.name} Switch`, 
                    segment.x, 520, 60, 60, `${vendor}Switch`);
                
                // Connect segment switch to VLAN and core switch
                graph.insertEdge(parent, null, '', segmentVLAN, segmentSwitch);
                graph.insertEdge(parent, null, '', coreSwitch, segmentSwitch);
                
                // Add IoT devices for this segment
                let deviceY = 600;
                segment.devices.forEach((device, i) => {
                    const iotDevice = graph.insertVertex(parent, null, device, 
                        segment.x - 40 + i * 40, deviceY, 60, 60, 'deviceIot');
                    
                    // Connect device to segment switch
                    graph.insertEdge(parent, null, '', iotDevice, segmentSwitch);
                });
            });
            
            // Add IoT device profiling box
            const profilingBox = graph.insertVertex(parent, null, 
                'IoT Device Profiling:\n• MAC OUI identification\n• Behavioral analysis\n• Protocol analysis\n• Classification rules\n• Automated categorization', 
                200, 180, 150, 100, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#ffe6cc;strokeColor=#d79b00;align=left;');
            
            // Add security controls box
            const securityBox = graph.insertVertex(parent, null, 
                'IoT Segmentation Security:\n• MAC Authentication Bypass (MAB)\n• Dynamic VLAN assignment\n• Micro-segmentation\n• Traffic filtering\n• Behavioral anomaly detection', 
                600, 180, 150, 100, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#e1d5e7;strokeColor=#9673a6;align=left;');
            
            // Add Segmentation Benefits box
            const benefitsBox = graph.insertVertex(parent, null, 
                'Segmentation Benefits:\n• Reduces attack surface\n• Limits lateral movement\n• Protects vulnerable devices\n• Ensures regulatory compliance\n• Simplifies device management', 
                800, 350, 150, 100, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#d5e8d4;strokeColor=#82b366;align=left;');
            
            // Add firewall
            const firewall = graph.insertVertex(parent, null, 'Firewall', 
                800, 480, 60, 60, `${vendor}Firewall`);
            
            // Add connections between segments through firewall
            segments.forEach(segment => {
                const vlan = graph.getModel().getCell(3 + segments.indexOf(segment) * 3 + 1); // Get the VLAN cell
                if (vlan) {
                    graph.insertEdge(parent, null, 'Controlled\nTraffic', vlan, firewall, 'dashed=1;dashPattern=1 4;');
                }
            });
            
            // Center the graph
            graph.center(true, true, 0.5, 0.5);
        } finally {
            graph.getModel().endUpdate();
        }
    };
    
    // Guest Access diagram
    const generateGuestAccess = function() {
        const parent = graph.getDefaultParent();
        
        graph.getModel().beginUpdate();
        try {
            // Add title
            const title = graph.insertVertex(parent, null, 'Guest Access with Portnox Cloud', 
                400, 20, 350, 30, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=16;fontStyle=1');
            
            // Add Portnox Cloud
            const portnoxCloud = graph.insertVertex(parent, null, 'Portnox Cloud', 
                400, 80, 150, 60, 'portnoxCloud');
            
            // Add Captive Portal
            const captivePortal = graph.insertVertex(parent, null, 'Guest Portal', 
                600, 80, 150, 60, 'shape=rectangle;rounded=1;fillColor=#dae8fc;strokeColor=#6c8ebf;');
            
            // Connect Portnox to Captive Portal
            graph.insertEdge(parent, null, 'Hosts', portnoxCloud, captivePortal);
            
            // Add RADIUS Server
            const radiusServer = graph.insertVertex(parent, null, 'Portnox RADIUS', 
                400, 180, 150, 60, 'portnoxRadius');
            
            // Connect Portnox Cloud to RADIUS
            graph.insertEdge(parent, null, 'API', portnoxCloud, radiusServer);
            
            // Add Corporate and Guest Networks
            const corpNetwork = graph.insertVertex(parent, null, 'Corporate Network', 
                250, 280, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#d5e8d4;strokeColor=#82b366;');
            
            const guestNetwork = graph.insertVertex(parent, null, 'Guest Network', 
                550, 280, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#ffe6cc;strokeColor=#d79b00;');
            
            // Connect RADIUS to networks
            graph.insertEdge(parent, null, 'RADIUS', radiusServer, corpNetwork);
            graph.insertEdge(parent, null, 'RADIUS', radiusServer, guestNetwork);
            
            // Add network infrastructure
            const vendor = currentConfig.vendor || 'cisco';
            
            // Corporate infrastructure
            const corpSwitch = graph.insertVertex(parent, null, 'Corporate Switch', 
                200, 380, 60, 60, `${vendor}Switch`);
            
            const corpAP = graph.insertVertex(parent, null, 'Corporate AP', 
                300, 380, 60, 60, `${vendor}WirelessAP`);
            
            // Guest infrastructure
            const guestSwitch = graph.insertVertex(parent, null, 'Guest Switch', 
                500, 380, 60, 60, `${vendor}Switch`);
            
            const guestAP = graph.insertVertex(parent, null, 'Guest AP', 
                600, 380, 60, 60, `${vendor}WirelessAP`);
            
            // Connect network devices to networks
            graph.insertEdge(parent, null, '', corpSwitch, corpNetwork);
            graph.insertEdge(parent, null, '', corpAP, corpNetwork);
            graph.insertEdge(parent, null, '', guestSwitch, guestNetwork);
            graph.insertEdge(parent, null, '', guestAP, guestNetwork);
            
            // Add firewall between networks
            const firewall = graph.insertVertex(parent, null, 'Firewall', 
                400, 330, 60, 60, `${vendor}Firewall`);
            
            // Connect firewall to networks
            graph.insertEdge(parent, null, 'Restricted\nAccess', corpNetwork, firewall);
            graph.insertEdge(parent, null, 'Internet\nOnly', firewall, guestNetwork);
            
            // Add Guest Access Flow
            const flowStart = graph.insertVertex(parent, null, 'Guest Connects', 
                400, 500, 120, 40, 'shape=process;whiteSpace=wrap;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // Connect guest device to WiFi
            const guestDevice = graph.insertVertex(parent, null, 'Guest Device', 
                600, 500, 60, 60, 'deviceByod');
            
            // Connect guest device to guest AP
            graph.insertEdge(parent, null, '', guestDevice, guestAP);
            
            // Create guest access flow steps
            const flowSteps = [
                { text: '1. Guest connects to guest WiFi', y: 580 },
                { text: '2. Redirected to captive portal', y: 630 },
                { text: '3. Self-registration or sponsor approval', y: 680 },
                { text: '4. Temporary credentials provided', y: 730 },
                { text: '5. Limited network access granted', y: 780 }
            ];
            
            // Add guest flow steps
            let prevStep = flowStart;
            flowSteps.forEach((step, i) => {
                const flowStep = graph.insertVertex(parent, null, step.text, 
                    400, step.y, 250, 40, 'shape=process;whiteSpace=wrap;fillColor=#f5f5f5;strokeColor=#666666;');
                
                // Connect to previous step
                graph.insertEdge(parent, null, '', prevStep, flowStep);
                
                prevStep = flowStep;
            });
            
            // Add Guest Portal Features box
            const featuresBox = graph.insertVertex(parent, null, 
                'Guest Portal Features:\n• Self-registration\n• Sponsor approval\n• Social login\n• Terms & conditions\n• Custom branding\n• Usage policy\n• Time-limited access\n• Usage tracking', 
                750, 200, 150, 150, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#dae8fc;strokeColor=#6c8ebf;align=left;');
            
            // Add Guest Auth Methods box
            const authBox = graph.insertVertex(parent, null, 
                'Guest Authentication Methods:\n• Web Authentication\n• SMS verification\n• Email verification\n• Sponsor verification\n• Social login\n• Vouchers/access codes', 
                150, 200, 150, 120, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#fff2cc;strokeColor=#d6b656;align=left;');
            
            // Add corporate devices
            const corpDevice = graph.insertVertex(parent, null, 'Corporate Device', 
                200, 500, 60, 60, 'deviceDesktop');
            
            // Connect corporate device
            graph.insertEdge(parent, null, '', corpDevice, corpSwitch);
            
            // Center the graph
            graph.center(true, true, 0.5, 0.5);
        } finally {
            graph.getModel().endUpdate();
        }
    };
    
    // Zoom in function
    const zoomIn = function() {
        if (graph) {
            graph.zoomIn();
        }
    };
    
    // Zoom out function
    const zoomOut = function() {
        if (graph) {
            graph.zoomOut();
        }
    };
    
    // Reset zoom function
    const zoomActual = function() {
        if (graph) {
            graph.zoomActual();
        }
    };
    
    // Export diagram as image or XML
    const exportDiagram = function(format) {
        if (!graph) {
            console.error('Graph not initialized');
            return null;
        }
        
        try {
            if (format === 'png') {
                // Create a canvas for PNG export
                const bounds = graph.getGraphBounds();
                const canvas = document.createElement('canvas');
                
                // Scale appropriately
                const scale = 1;
                canvas.width = Math.max(1, Math.ceil(bounds.width * scale + 2));
                canvas.height = Math.max(1, Math.ceil(bounds.height * scale + 2));
                
                // Render graph to canvas
                const ctx = canvas.getContext('2d');
                ctx.scale(scale, scale);
                ctx.translate(-bounds.x, -bounds.y);
                
                // Draw SVG to canvas
                const svgString = new XMLSerializer().serializeToString(diagramContainer.querySelector('svg'));
                return new Promise((resolve, reject) => {
                    const img = new Image();
                    img.onload = function() {
                        ctx.drawImage(img, 0, 0);
                        resolve(canvas.toDataURL('image/png'));
                    };
                    img.onerror = function(error) {
                        reject(error);
                    };
                    img.src = 'data:image/svg+xml;base64,' + btoa(unescape(encodeURIComponent(svgString)));
                });
            } else if (format === 'svg') {
                // Get SVG content
                const svg = diagramContainer.querySelector('svg').cloneNode(true);
                
                // Add XML declaration and doctype
                return '<?xml version="1.0" encoding="UTF-8"?>\n' +
                       '<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">\n' +
                       new XMLSerializer().serializeToString(svg);
            } else if (format === 'xml') {
                // Export graph model as XML
                const encoder = new mxCodec();
                const result = encoder.encode(graph.getModel());
                return mxUtils.getXml(result);
            } else {
                console.error('Unsupported format:', format);
                return null;
            }
        } catch (e) {
            console.error('Error exporting diagram:', e);
            return null;
        }
    };
    
    // Public API
    return {
        initialize: initialize,
        generateDiagram: generateDiagram,
        zoomIn: zoomIn,
        zoomOut: zoomOut,
        zoomActual: zoomActual,
        exportDiagram: exportDiagram
    };
})();
EOL

# Create diagram UI file
echo -e "${YELLOW}Creating diagram UI JavaScript...${NC}"
cat > js/diagrams/diagram-ui.js << 'EOL'
/**
 * Portnox NAC Diagram UI for UaXSupreme
 * @version 1.0.0
 * 
 * User interface for generating and managing Portnox Cloud NAC diagrams
 */

const PortnoxDiagramUI = (function() {
    // Private variables
    let diagramInitialized = false;
    let currentDiagramType = 'basic_cloud_deployment';
    
    // Initialize the diagram UI
    const initialize = function() {
        // Add diagram UI to the documentation tab
        injectDiagramUI();
        
        // Register event handlers
        registerEventHandlers();
    };
    
    // Inject the diagram UI into the page
    const injectDiagramUI = function() {
        const documentationTab = document.querySelector('.tab-pane[data-step="documentation"]');
        if (!documentationTab) {
            console.warn('Documentation tab not found, creating temporary container');
            
            // Create a temporary container if documentation tab doesn't exist
            const tempContainer = document.createElement('div');
            tempContainer.id = 'portnox-diagram-section';
            tempContainer.className = 'diagram-section mt-4';
            tempContainer.innerHTML = createDiagramUI();
            
            // Add after the main content or at the end of body
            const mainContent = document.querySelector('main') || document.body;
            mainContent.appendChild(tempContainer);
        } else {
            // Add to documentation tab
            const diagramSection = document.createElement('div');
            diagramSection.id = 'portnox-diagram-section';
            diagramSection.className = 'diagram-section mt-4';
            diagramSection.innerHTML = createDiagramUI();
            documentationTab.appendChild(diagramSection);
        }
    };
    
    // Create HTML for the diagram UI
    const createDiagramUI = function() {
        return `
        <div class="card mb-4">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="m-0">Portnox Cloud Network Diagrams</h5>
                <button type="button" class="btn btn-sm btn-outline-secondary" data-toggle="collapse" data-target="#diagramOptionsCollapse" aria-expanded="true">
                    <i class="fas fa-cog"></i> Options
                </button>
            </div>
            <div class="card-body">
                <div class="collapse show" id="diagramOptionsCollapse">
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <h6>Diagram Type</h6>
                            <div class="form-group">
                                <select class="form-control" id="diagram-type">
                                    <optgroup label="Deployment Scenarios">
                                        <option value="basic_cloud_deployment">Basic Cloud Deployment</option>
                                        <option value="enterprise_deployment">Enterprise Deployment</option>
                                        <option value="multi_vendor_deployment">Multi-Vendor Deployment</option>
                                        <option value="high_security_deployment">High Security Deployment</option>
                                        <option value="cloud_integration">Cloud Service Integration</option>
                                        <option value="multi_site_deployment">Multi-Site Deployment</option>
                                    </optgroup>
                                    <optgroup label="Industry Specific">
                                        <option value="healthcare_deployment">Healthcare Deployment</option>
                                        <option value="education_deployment">Education Deployment</option>
                                        <option value="retail_deployment">Retail Deployment</option>
                                        <option value="manufacturing_deployment">Manufacturing Deployment</option>
                                        <option value="government_deployment">Government Deployment</option>
                                        <option value="financial_deployment">Financial Services Deployment</option>
                                    </optgroup>
                                    <optgroup label="Authentication & Workflows">
                                        <option value="eap_tls_authentication">EAP-TLS Authentication Flow</option>
                                        <option value="byod_onboarding">BYOD Onboarding Flow</option>
                                        <option value="guest_access">Guest Access Portal</option>
                                        <option value="dynamic_vlan_assignment">Dynamic VLAN Assignment</option>
                                        <option value="iot_segmentation">IoT Segmentation</option>
                                    </optgroup>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="vendor-select">Network Equipment Vendor</label>
                                <select class="form-control" id="vendor-select">
                                    <option value="cisco">Cisco</option>
                                    <option value="aruba">Aruba</option>
                                    <option value="juniper">Juniper</option>
                                    <option value="extreme">Extreme</option>
                                    <option value="fortinet">Fortinet</option>
                                    <option value="paloalto">Palo Alto</option>
                                    <option value="hp">HP Enterprise</option>
                                    <option value="dell">Dell</option>
                                    <option value="arista">Arista</option>
                                </select>
                            </div>
                            <button id="generate-diagram-btn" class="btn btn-primary mt-2">
                                <i class="fas fa-project-diagram mr-2"></i>Generate Diagram
                            </button>
                        </div>
                        <div class="col-md-6">
                            <h6>Diagram Components</h6>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="show-radius" checked>
                                <label class="form-check-label" for="show-radius">
                                    Show RADIUS Server
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="show-auth" checked>
                                <label class="form-check-label" for="show-auth">
                                    Show Authentication Methods
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="show-clients" checked>
                                <label class="form-check-label" for="show-clients">
                                    Show Client Devices
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="show-cloud" checked>
                                <label class="form-check-label" for="show-cloud">
                                    Show Cloud Services
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="show-legends" checked>
                                <label class="form-check-label" for="show-legends">
                                    Show Legends & Notes
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="show-detailed" checked>
                                <label class="form-check-label" for="show-detailed">
                                    Show Detailed Components
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div id="diagram-status" class="alert d-none"></div>
                
                <div id="diagram-container" class="diagram-container d-none">
                    <div class="diagram-toolbar">
                        <button id="zoom-in-btn" title="Zoom In">
                            <i class="fas fa-search-plus"></i>
                        </button>
                        <button id="zoom-out-btn" title="Zoom Out">
                            <i class="fas fa-search-minus"></i>
                        </button>
                        <button id="zoom-reset-btn" title="Reset Zoom">
                            <i class="fas fa-compress"></i>
                        </button>
                        <span class="toolbar-separator"></span>
                        <button id="export-png-btn" title="Export as PNG">
                            <i class="fas fa-file-image"></i> PNG
                        </button>
                        <button id="export-svg-btn" title="Export as SVG">
                            <i class="fas fa-file-code"></i> SVG
                        </button>
                        <button id="add-to-config-btn" title="Add to Configuration" class="ml-auto">
                            <i class="fas fa-plus-circle"></i> Add to Configuration
                        </button>
                    </div>
                    <div id="diagram-canvas" class="diagram-canvas"></div>
                </div>
                
                <h6 class="mt-4">Recommended Diagrams</h6>
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <div class="template-card" data-template="basic_cloud_deployment">
                            <div class="template-thumbnail">
                                <i class="fas fa-network-wired"></i>
                            </div>
                            <div class="template-title">Basic Cloud Deployment</div>
                            <div class="template-description">Standard Portnox Cloud NAC deployment</div>
                        </div>
                    </div>
                    <div class="col-md-4 mb-3">
                        <div class="template-card" data-template="eap_tls_authentication">
                            <div class="template-thumbnail">
                                <i class="fas fa-key"></i>
                            </div>
                            <div class="template-title">EAP-TLS Authentication</div>
                            <div class="template-description">Certificate-based authentication flow</div>
                        </div>
                    </div>
                    <div class="col-md-4 mb-3">
                        <div class="template-card" data-template="dynamic_vlan_assignment">
                            <div class="template-thumbnail">
                                <i class="fas fa-project-diagram"></i>
                            </div>
                            <div class="template-title">Dynamic VLAN Assignment</div>
                            <div class="template-description">Role and device-based network segmentation</div>
                        </div>
                    </div>
                </div>
                
                <h6 class="mt-4">Industry-Specific Diagrams</h6>
                <div class="row">
                    <div class="col-md-3 mb-3">
                        <div class="template-card" data-template="healthcare_deployment">
                            <div class="template-thumbnail">
                                <i class="fas fa-hospital"></i>
                            </div>
                            <div class="template-title">Healthcare</div>
                            <div class="template-description">HIPAA-compliant segmentation</div>
                        </div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <div class="template-card" data-template="financial_deployment">
                            <div class="template-thumbnail">
                                <i class="fas fa-university"></i>
                            </div>
                            <div class="template-title">Financial</div>
                            <div class="template-description">PCI-DSS compliance for banking</div>
                        </div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <div class="template-card" data-template="education_deployment">
                            <div class="template-thumbnail">
                                <i class="fas fa-graduation-cap"></i>
                            </div>
                            <div class="template-title">Education</div>
                            <div class="template-description">Campus NAC with BYOD</div>
                        </div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <div class="template-card" data-template="manufacturing_deployment">
                            <div class="template-thumbnail">
                                <i class="fas fa-industry"></i>
                            </div>
                            <div class="template-title">Manufacturing</div>
                            <div class="template-description">OT/IT convergence security</div>
                        </div>
                    </div>
                </div>
                
                <div class="mt-4 p-3 bg-light rounded">
                    <h6><i class="fas fa-info-circle mr-2"></i>Portnox NAC Deployment Best Practices</h6>
                    <ul>
                        <li>Deploy in monitor mode first before enforcing authentication</li>
                        <li>Set up a guest VLAN for unauthenticated or guest devices</li>
                        <li>Use EAP-TLS with certificates for corporate-owned devices</li>
                        <li>Configure MAC Authentication Bypass (MAB) for IoT devices</li>
                        <li>Implement dynamic VLAN assignment based on device type and posture</li>
                        <li>Integrate with existing identity sources (Azure AD, Okta, etc.)</li>
                        <li>Set up compliance checks with MDM integration</li>
                        <li>Configure redundant RADIUS servers for high availability</li>
                    </ul>
                    <button class="btn btn-sm btn-info" id="show-best-practices">View Complete Best Practices</button>
                </div>
            </div>
        </div>
        `;
    };
    
    // Register event handlers
    const registerEventHandlers = function() {
        // Ensure DOM is loaded before attaching events
        document.addEventListener('DOMContentLoaded', function() {
            // Generate diagram button
            const generateBtn = document.getElementById('generate-diagram-btn');
            if (generateBtn) {
                generateBtn.addEventListener('click', handleGenerateDiagram);
            }
            
            // Diagram type select
            const diagramTypeSelect = document.getElementById('diagram-type');
            if (diagramTypeSelect) {
                diagramTypeSelect.addEventListener('change', function() {
                    currentDiagramType = this.value;
                });
            }
            
            // Template cards
            const templateCards = document.querySelectorAll('.template-card');
            templateCards.forEach(function(card) {
                card.addEventListener('click', function() {
                    const template = this.getAttribute('data-template');
                    if (template) {
                        currentDiagramType = template;
                        if (diagramTypeSelect) {
                            diagramTypeSelect.value = template;
                        }
                        handleGenerateDiagram();
                    }
                });
            });
            
            // Zoom buttons
            const zoomInBtn = document.getElementById('zoom-in-btn');
            const zoomOutBtn = document.getElementById('zoom-out-btn');
            const zoomResetBtn = document.getElementById('zoom-reset-btn');
            
            if (zoomInBtn) {
                zoomInBtn.addEventListener('click', function() {
                    if (diagramInitialized) {
                        PortnoxDiagramGenerator.zoomIn();
                        updateStatus('Zoomed in', 'success');
                    }
                });
            }
            
            if (zoomOutBtn) {
                zoomOutBtn.addEventListener('click', function() {
                    if (diagramInitialized) {
                        PortnoxDiagramGenerator.zoomOut();
                        updateStatus('Zoomed out', 'success');
                    }
                });
            }
            
            if (zoomResetBtn) {
                zoomResetBtn.addEventListener('click', function() {
                    if (diagramInitialized) {
                        PortnoxDiagramGenerator.zoomActual();
                        updateStatus('Zoom reset', 'success');
                    }
                });
            }
            
            // Export buttons
            const exportPngBtn = document.getElementById('export-png-btn');
            const exportSvgBtn = document.getElementById('export-svg-btn');
            
            if (exportPngBtn) {
                exportPngBtn.addEventListener('click', function() {
                    handleExport('png');
                });
            }
            
            if (exportSvgBtn) {
                exportSvgBtn.addEventListener('click', function() {
                    handleExport('svg');
                });
            }
            
            // Add to Configuration button
            const addToConfigBtn = document.getElementById('add-to-config-btn');
            if (addToConfigBtn) {
                addToConfigBtn.addEventListener('click', function() {
                    addDiagramToConfiguration();
                });
            }
            
            // Best Practices button
            const bestPracticesBtn = document.getElementById('show-best-practices');
            if (bestPracticesBtn) {
                bestPracticesBtn.addEventListener('click', function() {
                    showBestPracticesModal();
                });
            }
        });
    };
    
    // Handle generate diagram button click
    const handleGenerateDiagram = function() {
        const diagramContainer = document.getElementById('diagram-container');
        const diagramCanvas = document.getElementById('diagram-canvas');
        
        if (!diagramContainer || !diagramCanvas) {
            updateStatus('Diagram container not found', 'error');
            return;
        }
        
        updateStatus('Generating diagram...', 'info');
        
        // Show the diagram container
        diagramContainer.classList.remove('d-none');
        
        // Get diagram options
        const showRadius = document.getElementById('show-radius')?.checked ?? true;
        const showAuth = document.getElementById('show-auth')?.checked ?? true;
        const showClients = document.getElementById('show-clients')?.checked ?? true;
        const showCloud = document.getElementById('show-cloud')?.checked ?? true;
        const showLegends = document.getElementById('show-legends')?.checked ?? true;
        const showDetailed = document.getElementById('show-detailed')?.checked ?? true;
        const vendor = document.getElementById('vendor-select')?.value || 'cisco';
        
        // Create config object
        const config = {
            showRadius,
            showAuth,
            showClients,
            showCloud,
            showLegends,
            showDetailed,
            vendor
        };
        
        // Initialize diagram if not already done
        if (!diagramInitialized) {
            diagramInitialized = PortnoxDiagramGenerator.initialize('diagram-canvas');
            if (!diagramInitialized) {
                updateStatus('Failed to initialize diagram generator', 'error');
                return;
            }
        }
        
        // Generate the diagram
        try {
            const success = PortnoxDiagramGenerator.generateDiagram(config, currentDiagramType);
            if (success) {
                updateStatus(`Successfully generated ${getReadableDiagramType(currentDiagramType)} diagram`, 'success');
            } else {
                updateStatus('Error generating diagram', 'error');
            }
        } catch (error) {
            updateStatus('Error: ' + error.message, 'error');
            console.error('Error generating diagram:', error);
        }
    };
    
    // Handle export button click
    const handleExport = function(format) {
        if (!diagramInitialized) {
            updateStatus('Diagram not initialized', 'error');
            return;
        }
        
        updateStatus(`Exporting diagram as ${format.toUpperCase()}...`, 'info');
        
        try {
            const resultPromise = PortnoxDiagramGenerator.exportDiagram(format);
            
            if (resultPromise instanceof Promise) {
                resultPromise.then(function(result) {
                    downloadDiagram(result, format);
                    updateStatus(`Successfully exported diagram as ${format.toUpperCase()}`, 'success');
                }).catch(function(error) {
                    updateStatus('Error exporting diagram: ' + error.message, 'error');
                    console.error('Error exporting diagram:', error);
                });
            } else {
                downloadDiagram(resultPromise, format);
                updateStatus(`Successfully exported diagram as ${format.toUpperCase()}`, 'success');
            }
        } catch (error) {
            updateStatus('Error exporting diagram: ' + error.message, 'error');
            console.error('Error exporting diagram:', error);
        }
    };
    
    // Helper to download the diagram
    const downloadDiagram = function(data, format) {
        if (!data) {
            updateStatus(`Failed to export diagram as ${format.toUpperCase()}`, 'error');
            return;
        }
        
        // Create download link
        const link = document.createElement('a');
        const diagramName = getReadableDiagramType(currentDiagramType).replace(/\s+/g, '_').toLowerCase();
        const filename = `portnox_${diagramName}_${new Date().toISOString().slice(0, 10)}.${format}`;
        
        if (format === 'png') {
            link.href = data;
            link.download = filename;
        } else if (format === 'svg') {
            const blob = new Blob([data], { type: 'image/svg+xml' });
            link.href = URL.createObjectURL(blob);
            link.download = filename;
        } else if (format === 'xml') {
            const blob = new Blob([data], { type: 'application/xml' });
            link.href = URL.createObjectURL(blob);
            link.download = `portnox_${diagramName}.xml`;
        }
        
        // Trigger download
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    };
    
    // Add the current diagram to the configuration
    const addDiagramToConfiguration = function() {
        if (!diagramInitialized) {
            updateStatus('No diagram to add to configuration', 'error');
            return;
        }
        
        try {
            // Export current diagram as SVG
            const svgData = PortnoxDiagramGenerator.exportDiagram('svg');
            
            // Add to configuration if possible
            if (typeof window.UaXSupreme !== 'undefined' && typeof window.UaXSupreme.addAsset === 'function') {
                const diagramName = getReadableDiagramType(currentDiagramType);
                const assetName = `portnox_${diagramName.replace(/\s+/g, '_').toLowerCase()}.svg`;
                
                window.UaXSupreme.addAsset({
                    name: assetName,
                    type: 'diagram',
                    data: svgData,
                    description: `Portnox Cloud NAC diagram for ${diagramName}`
                });
                
                updateStatus('Diagram added to configuration', 'success');
            } else {
                updateStatus('Configuration API not available', 'error');
            }
        } catch (error) {
            updateStatus('Error adding diagram to configuration: ' + error.message, 'error');
            console.error('Error adding diagram to configuration:', error);
        }
    };
    
    // Show best practices modal
    const showBestPracticesModal = function() {
        // Create modal if it doesn't exist
        let modal = document.getElementById('portnox-best-practices-modal');
        
        if (!modal) {
            modal = document.createElement('div');
            modal.id = 'portnox-best-practices-modal';
            modal.className = 'modal fade';
            modal.setAttribute('tabindex', '-1');
            modal.setAttribute('role', 'dialog');
            modal.setAttribute('aria-labelledby', 'portnoxBestPracticesTitle');
            modal.setAttribute('aria-hidden', 'true');
            
            modal.innerHTML = `
                <div class="modal-dialog modal-lg" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="portnoxBestPracticesTitle">Portnox Cloud NAC Best Practices</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <div class="nav nav-tabs" id="bestPracticesTabs" role="tablist">
                                <a class="nav-item nav-link active" id="general-tab" data-toggle="tab" href="#general" role="tab" aria-controls="general" aria-selected="true">General</a>
                                <a class="nav-item nav-link" id="deployment-tab" data-toggle="tab" href="#deployment" role="tab" aria-controls="deployment" aria-selected="false">Deployment</a>
                                <a class="nav-item nav-link" id="auth-tab" data-toggle="tab" href="#auth" role="tab" aria-controls="auth" aria-selected="false">Authentication</a>
                                <a class="nav-item nav-link" id="security-tab" data-toggle="tab" href="#security" role="tab" aria-controls="security" aria-selected="false">Security</a>
                                <a class="nav-item nav-link" id="industry-tab" data-toggle="tab" href="#industry" role="tab" aria-controls="industry" aria-selected="false">Industry-Specific</a>
                            </div>
                            <div class="tab-content p-3" id="bestPracticesTabContent">
                                <div class="tab-pane fade show active" id="general" role="tabpanel" aria-labelledby="general-tab">
                                    <h6>General Best Practices</h6>
                                    <ul>
                                        <li><strong>Phased Approach</strong>: Start with monitor mode before enforcing authentication</li>
                                        <li><strong>Network Visibility</strong>: Use Portnox to gain complete device visibility before enforcement</li>
                                        <li><strong>Documentation</strong>: Document existing network infrastructure, VLANs, and security requirements</li>
                                        <li><strong>Stakeholder Engagement</strong>: Involve IT, security, and business stakeholders in the planning</li>
                                        <li><strong>Training</strong>: Ensure IT staff are trained on NAC concepts and Portnox management</li>
                                        <li><strong>Help Desk</strong>: Prepare help desk with troubleshooting procedures for authentication issues</li>
                                        <li><strong>User Communication</strong>: Notify users about NAC implementation and expected changes</li>
                                        <li><strong>Testing</strong>: Test all device types and authentication scenarios before full deployment</li>
                                    </ul>
                                </div>
                                <div class="tab-pane fade" id="deployment" role="tabpanel" aria-labelledby="deployment-tab">
                                    <h6>Deployment Best Practices</h6>
                                    <ul>
                                        <li><strong>Redundancy</strong>: Deploy multiple RADIUS servers for high availability</li>
                                        <li><strong>Guest Network</strong>: Set up a separate guest VLAN with appropriate security controls</li>
                                        <li><strong>Segmentation</strong>: Implement VLANs for different device categories and security levels</li>
                                        <li><strong>Fallback Options</strong>: Configure fallback authentication methods for critical systems</li>
                                        <li><strong>Monitoring</strong>: Implement monitoring for RADIUS servers and authentication events</li>
                                        <li><strong>Device Profiling</strong>: Use profiling to accurately identify and categorize devices</li>
                                        <li><strong>Integration</strong>: Integrate with existing infrastructure and security tools</li>
                                        <li><strong>Scalability</strong>: Plan for future growth in device numbers and locations</li>
                                    </ul>
                                </div>
                                <div class="tab-pane fade" id="auth" role="tabpanel" aria-labelledby="auth-tab">
                                    <h6>Authentication Best Practices</h6>
                                    <ul>
                                        <li><strong>Corporate Devices</strong>: Use certificate-based authentication (EAP-TLS) for managed devices</li>
                                        <li><strong>BYOD</strong>: Implement secure onboarding with device registration and posture assessment</li>
                                        <li><strong>IoT Devices</strong>: Use MAC Authentication Bypass (MAB) with device profiling</li>
                                        <li><strong>Guest Access</strong>: Implement captive portal with registration and limited access</li>
                                        <li><strong>Multi-factor Authentication</strong>: Require MFA for sensitive access scenarios</li>
                                        <li><strong>Certificate Management</strong>: Implement secure certificate lifecycle management</li>
                                        <li><strong>Password Policies</strong>: Enforce strong password policies where passwords are used</li>
                                        <li><strong>Vendor Support</strong>: Verify NAC compatibility with all network infrastructure vendors</li>
                                    </ul>
                                </div>
                                <div class="tab-pane fade" id="security" role="tabpanel" aria-labelledby="security-tab">
                                    <h6>Security Best Practices</h6>
                                    <ul>
                                        <li><strong>Posture Assessment</strong>: Check device compliance before granting network access</li>
                                        <li><strong>Continuous Monitoring</strong>: Continuously verify device compliance and behavior</li>
                                        <li><strong>Least Privilege</strong>: Grant minimal necessary access based on device and user</li>
                                        <li><strong>Remediation</strong>: Provide self-remediation options for non-compliant devices</li>
                                        <li><strong>Incident Response</strong>: Integrate NAC with security incident response processes</li>
                                        <li><strong>Logging & Auditing</strong>: Maintain comprehensive logs for compliance and forensics</li>
                                        <li><strong>Encryption</strong>: Enforce encryption for all authentication and management traffic</li>
                                        <li><strong>Rogue Device Detection</strong>: Identify and isolate unauthorized devices</li>
                                    </ul>
                                </div>
                                <div class="tab-pane fade" id="industry" role="tabpanel" aria-labelledby="industry-tab">
                                    <h6>Industry-Specific Best Practices</h6>
                                    <ul>
                                        <li><strong>Healthcare</strong>: Implement strict segmentation for medical devices, ensure HIPAA compliance</li>
                                        <li><strong>Financial</strong>: Meet PCI-DSS requirements, implement multi-factor authentication, strict access controls</li>
                                        <li><strong>Education</strong>: Support diverse BYOD environments, implement role-based access for students/faculty</li>
                                        <li><strong>Manufacturing</strong>: Secure OT/IT convergence, protect industrial control systems</li>
                                        <li><strong>Retail</strong>: Isolate POS systems, secure guest WiFi, protect customer data</li>
                                        <li><strong>Government</strong>: Meet FIPS, NIST, and agency-specific requirements</li>
                                        <li><strong>Transportation</strong>: Protect operational technology, support mobile workforce</li>
                                        <li><strong>Utilities</strong>: Secure critical infrastructure, meet regulatory requirements</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            `;
            
            document.body.appendChild(modal);
        }
        
        // Show the modal
        if (typeof $ !== 'undefined') {
            $('#portnox-best-practices-modal').modal('show');
        } else {
            const modalElem = document.getElementById('portnox-best-practices-modal');
            modalElem.classList.add('show');
            modalElem.style.display = 'block';
            modalElem.setAttribute('aria-hidden', 'false');
            document.body.classList.add('modal-open');
            
            // Add backdrop
            const backdrop = document.createElement('div');
            backdrop.className = 'modal-backdrop fade show';
            document.body.appendChild(backdrop);
            
            // Add close handlers
            const closeButtons = modalElem.querySelectorAll('[data-dismiss="modal"]');
            closeButtons.forEach(function(button) {
                button.addEventListener('click', function() {
                    modalElem.classList.remove('show');
                    modalElem.style.display = 'none';
                    modalElem.setAttribute('aria-hidden', 'true');
                    document.body.classList.remove('modal-open');
                    document.body.removeChild(backdrop);
                });
            });
        }
    };
    
    // Update status message
    const updateStatus = function(message, type) {
        const statusElement = document.getElementById('diagram-status');
        if (statusElement) {
            statusElement.textContent = message;
            statusElement.className = `alert alert-${type === 'error' ? 'danger' : (type === 'info' ? 'info' : 'success')}`;
            statusElement.classList.remove('d-none');
            
            // Hide after delay for success messages
            if (type === 'success') {
                setTimeout(() => {
                    statusElement.classList.add('d-none');
                }, 3000);
            }
        }
    };
    
    // Get readable diagram type name from key
    const getReadableDiagramType = function(type) {
        const typeMap = {
            'basic_cloud_deployment': 'Basic Cloud Deployment',
            'enterprise_deployment': 'Enterprise Deployment',
            'healthcare_deployment': 'Healthcare Deployment',
            'education_deployment': 'Education Deployment',
            'retail_deployment': 'Retail Deployment',
            'manufacturing_deployment': 'Manufacturing Deployment',
            'government_deployment': 'Government Deployment',
            'financial_deployment': 'Financial Services Deployment',
            'eap_tls_authentication': 'EAP-TLS Authentication Flow',
            'byod_onboarding': 'BYOD Onboarding Flow',
            'dynamic_vlan_assignment': 'Dynamic VLAN Assignment',
            'multi_vendor_deployment': 'Multi-Vendor Deployment',
            'high_security_deployment': 'High Security Deployment',
            'cloud_integration': 'Cloud Integration',
            'multi_site_deployment': 'Multi-Site Deployment',
            'iot_segmentation': 'IoT Segmentation',
            'guest_access': 'Guest Access'
        };
        
        return typeMap[type] || type.replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase());
    };
    
    // Public API
    return {
        initialize: initialize
    };
})();
EOL

# Create the CSS file for diagram styling
echo -e "${YELLOW}Creating diagram CSS styles...${NC}"
cat > css/diagrams/diagram-styles.css << 'EOL'
/**
 * Portnox NAC Diagram styles
 * These styles define the appearance of diagrams and diagram UI elements
 */

/* Diagram container */
.diagram-container {
    width: 100%;
    height: 600px;
    border: 1px solid #ddd;
    border-radius: 4px;
    background-color: #f9f9f9;
    position: relative;
    overflow: hidden;
    margin-bottom: 20px;
    transition: height 0.3s ease;
}

/* Make diagram container responsive */
@media (max-width: 768px) {
    .diagram-container {
        height: 400px;
    }
}

/* Diagram toolbar */
.diagram-toolbar {
    background-color: #f0f0f0;
    border-bottom: 1px solid #ddd;
    height: 40px;
    display: flex;
    align-items: center;
    padding: 0 10px;
    z-index: 1;
}

.diagram-toolbar button {
    margin-right: 8px;
    background-color: transparent;
    border: none;
    border-radius: 3px;
    padding: 5px 8px;
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    font-size: 14px;
}

.diagram-toolbar button:hover {
    background-color: #e0e0e0;
}

.diagram-toolbar button i {
    margin-right: 4px;
}

.toolbar-separator {
    height: 24px;
    width: 1px;
    background-color: #ccc;
    margin: 0 10px;
}

.diagram-toolbar .ml-auto {
    margin-left: auto;
}

/* Diagram canvas */
.diagram-canvas {
    position: absolute;
    top: 40px;
    left: 0;
    right: 0;
    bottom: 0;
    overflow: hidden;
}

/* Template cards */
.template-card {
    border: 1px solid #ddd;
    border-radius: 4px;
    padding: 15px;
    transition: all 0.2s ease;
    cursor: pointer;
    height: 100%;
    box-shadow: 0 1px 3px rgba(0,0,0,0.1);
}

.template-card:hover {
    border-color: #007bff;
    box-shadow: 0 4px 10px rgba(0,0,0,0.1);
    transform: translateY(-2px);
}

.template-thumbnail {
    display: flex;
    align-items: center;
    justify-content: center;
    height: 100px;
    background-color: #f5f5f5;
    border-radius: 4px;
    margin-bottom: 10px;
}

.template-thumbnail i {
    font-size: 40px;
    color: #0078D4;
}

.template-title {
    font-weight: bold;
    margin-bottom: 5px;
    font-size: 14px;
}

.template-description {
    font-size: 12px;
    color: #666;
}

/* Status message */
#diagram-status {
    padding: 10px;
    margin-bottom: 15px;
    border-radius: 4px;
}

/* Best practices modal */
#portnox-best-practices-modal .nav-tabs {
    border-bottom: 1px solid #dee2e6;
}

#portnox-best-practices-modal .nav-tabs .nav-link {
    margin-bottom: -1px;
    border: 1px solid transparent;
    border-top-left-radius: 0.25rem;
    border-top-right-radius: 0.25rem;
}

#portnox-best-practices-modal .nav-tabs .nav-link:hover,
#portnox-best-practices-modal .nav-tabs .nav-link:focus {
    border-color: #e9ecef #e9ecef #dee2e6;
}

#portnox-best-practices-modal .nav-tabs .nav-link.active {
    color: #495057;
    background-color: #fff;
    border-color: #dee2e6 #dee2e6 #fff;
}

#portnox-best-practices-modal .tab-content {
    background-color: #fff;
    border-left: 1px solid #dee2e6;
    border-right: 1px solid #dee2e6;
    border-bottom: 1px solid #dee2e6;
    border-bottom-left-radius: 0.25rem;
    border-bottom-right-radius: 0.25rem;
}

#portnox-best-practices-modal .tab-content ul {
    padding-left: 20px;
}

#portnox-best-practices-modal .tab-content li {
    margin-bottom: 8px;
}

/* Dark mode support */
@media (prefers-color-scheme: dark) {
    .dark-mode .diagram-container {
        background-color: #2d2d2d;
        border-color: #444;
    }
    
    .dark-mode .diagram-toolbar {
        background-color: #333;
        border-color: #444;
    }
    
    .dark-mode .diagram-toolbar button {
        color: #eee;
    }
    
    .dark-mode .diagram-toolbar button:hover {
        background-color: #444;
    }
    
    .dark-mode .template-card {
        background-color: #333;
        border-color: #444;
    }
    
    .dark-mode .template-title {
        color: #f0f0f0;
    }
    
    .dark-mode .template-description {
        color: #aaa;
    }
    
    .dark-mode .template-thumbnail {
        background-color: #444;
    }
    
    .dark-mode #portnox-best-practices-modal .modal-content {
        background-color: #333;
        color: #eee;
    }
    
    .dark-mode #portnox-best-practices-modal .nav-tabs .nav-link.active {
        color: #eee;
        background-color: #444;
        border-color: #555 #555 #444;
    }
    
    .dark-mode #portnox-best-practices-modal .tab-content {
        background-color: #444;
        border-color: #555;
    }
    
    .dark-mode #portnox-best-practices-modal .close {
        color: #eee;
    }
}
EOL

# Create icons for network device vendors
echo -e "${YELLOW}Creating vendor icons...${NC}"

# Function to create vendor icon
create_vendor_icon() {
    local name="$1"
    local color="$2"
    
    mkdir -p "images/stencils/vendors/$name"
    
    # Create switch icon
    cat > "images/stencils/vendors/$name/switch.svg" << EOF
<svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" viewBox="0 0 60 60">
  <rect x="5" y="20" width="50" height="20" rx="2" ry="2" fill="$color" stroke="#333333" stroke-width="2"/>
  <rect x="10" y="25" width="5" height="5" fill="#E6E6E6"/>
  <rect x="18" y="25" width="5" height="5" fill="#E6E6E6"/>
  <rect x="26" y="25" width="5" height="5" fill="#E6E6E6"/>
  <rect x="34" y="25" width="5" height="5" fill="#E6E6E6"/>
  <rect x="42" y="25" width="5" height="5" fill="#E6E6E6"/>
  <rect x="10" y="32" width="5" height="5" fill="#E6E6E6"/>
  <rect x="18" y="32" width="5" height="5" fill="#E6E6E6"/>
  <rect x="26" y="32" width="5" height="5" fill="#E6E6E6"/>
  <rect x="34" y="32" width="5" height="5" fill="#E6E6E6"/>
  <rect x="42" y="32" width="5" height="5" fill="#E6E6E6"/>
</svg>
EOF

    # Create router icon
    cat > "images/stencils/vendors/$name/router.svg" << EOF
<svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" viewBox="0 0 60 60">
  <rect x="5" y="20" width="50" height="15" rx="5" ry="5" fill="$color" stroke="#333333" stroke-width="2"/>
  <circle cx="15" cy="27.5" r="3" fill="#E6E6E6"/>
  <circle cx="25" cy="27.5" r="3" fill="#E6E6E6"/>
  <circle cx="35" cy="27.5" r="3" fill="#E6E6E6"/>
  <circle cx="45" cy="27.5" r="3" fill="#E6E6E6"/>
</svg>
EOF

    # Create wireless AP icon
    cat > "images/stencils/vendors/$name/wireless_ap.svg" << EOF
<svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" viewBox="0 0 60 60">
  <circle cx="30" cy="30" r="15" fill="$color" stroke="#333333" stroke-width="2"/>
  <path d="M20,30 A10,10 0 0 1 40,30" stroke="#E6E6E6" stroke-width="1.5" fill="none"/>
  <path d="M23,25 A7,7 0 0 1 37,25" stroke="#E6E6E6" stroke-width="1.5" fill="none"/>
  <path d="M26,20 A4,4 0 0 1 34,20" stroke="#E6E6E6" stroke-width="1.5" fill="none"/>
</svg>
EOF

    # Create firewall icon
    cat > "images/stencils/vendors/$name/firewall.svg" << EOF
<svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" viewBox="0 0 60 60">
  <rect x="5" y="15" width="50" height="30" rx="2" ry="2" fill="$color" stroke="#333333" stroke-width="2"/>
  <path d="M15,15 L15,45" stroke="#E6E6E6" stroke-width="1"/>
  <path d="M25,15 L25,45" stroke="#E6E6E6" stroke-width="1"/>
  <path d="M35,15 L35,45" stroke="#E6E6E6" stroke-width="1"/>
  <path d="M45,15 L45,45" stroke="#E6E6E6" stroke-width="1"/>
  <path d="M5,25 L55,25" stroke="#E6E6E6" stroke-width="1"/>
  <path d="M5,35 L55,35" stroke="#E6E6E6" stroke-width="1"/>
</svg>
EOF

    # Create logo icon
    cat > "images/stencils/vendors/$name/logo.svg" << EOF
<svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" viewBox="0 0 60 60">
  <rect x="10" y="20" width="40" height="20" rx="5" ry="5" fill="$color" stroke="#333333" stroke-width="1"/>
  <text x="30" y="35" font-family="Arial" font-size="10" font-weight="bold" text-anchor="middle" fill="#FFFFFF">${name^^}</text>
</svg>
EOF

    echo -e "${GREEN}Created icons for $name${NC}"
}

# Create vendor icons with different colors
create_vendor_icon "cisco" "#1BA0D7"
create_vendor_icon "aruba" "#F68B1F"
create_vendor_icon "juniper" "#84B135"
create_vendor_icon "fortinet" "#EE3124"
create_vendor_icon "paloalto" "#FA582D"
create_vendor_icon "extreme" "#7ABB00"
create_vendor_icon "hp" "#0096D6"
create_vendor_icon "dell" "#007DB8"
create_vendor_icon "arista" "#2D7DE1"
create_vendor_icon "checkpoint" "#F04E23"
create_vendor_icon "ruckus" "#E31837"
create_vendor_icon "meraki" "#95C93D"

# Create device icons
echo -e "${YELLOW}Creating device icons...${NC}"

# BYOD device
cat > images/stencils/devices/byod.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" viewBox="0 0 60 60">
  <rect x="15" y="5" width="30" height="50" rx="3" ry="3" fill="#607D8B" stroke="#263238" stroke-width="2"/>
  <rect x="20" y="10" width="20" height="35" fill="#B0BEC5"/>
  <circle cx="30" cy="50" r="3" fill="#B0BEC5"/>
  <text x="30" y="28" font-family="Arial" font-size="7" text-anchor="middle" fill="#000">BYOD</text>
</svg>
SVGEOF

# IoT device
cat > images/stencils/devices/iot.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" viewBox="0 0 60 60">
  <rect x="10" y="20" width="40" height="25" rx="2" ry="2" fill="#00BCD4" stroke="#006064" stroke-width="2"/>
  <circle cx="20" cy="32" r="3" fill="#E0F7FA"/>
  <circle cx="30" cy="32" r="3" fill="#E0F7FA"/>
  <circle cx="40" cy="32" r="3" fill="#E0F7FA"/>
  <text x="30" y="15" font-family="Arial" font-size="7" text-anchor="middle" fill="#000">IoT Device</text>
</svg>
SVGEOF

# Desktop PC
cat > images/stencils/devices/desktop.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" viewBox="0 0 60 60">
  <rect x="10" y="10" width="30" height="25" rx="2" ry="2" fill="#455A64" stroke="#263238" stroke-width="2"/>
  <rect x="15" y="15" width="20" height="15" fill="#B0BEC5"/>
  <rect x="15" y="35" width="20" height="10" rx="1" ry="1" fill="#78909C" stroke="#455A64" stroke-width="1"/>
  <rect x="20" y="45" width="10" height="5" fill="#78909C" stroke="#455A64" stroke-width="1"/>
  <rect x="15" y="50" width="20" height="2" fill="#78909C" stroke="#455A64" stroke-width="1"/>
</svg>
SVGEOF

# Phone
cat > images/stencils/devices/phone.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" viewBox="0 0 60 60">
  <path d="M15,10 L45,10 L45,50 L15,50 Z" fill="#3F51B5" stroke="#1A237E" stroke-width="2"/>
  <rect x="20" y="15" width="20" height="15" fill="#C5CAE9"/>
  <rect x="20" y="35" width="5" height="5" rx="2" ry="2" fill="#C5CAE9"/>
  <rect x="27.5" y="35" width="5" height="5" rx="2" ry="2" fill="#C5CAE9"/>
  <rect x="35" y="35" width="5" height="5" rx="2" ry="2" fill="#C5CAE9"/>
  <rect x="20" y="42" width="5" height="5" rx="2" ry="2" fill="#C5CAE9"/>
  <rect x="27.5" y="42" width="5" height="5" rx="2" ry="2" fill="#C5CAE9"/>
  <rect x="35" y="42" width="5" height="5" rx="2" ry="2" fill="#C5CAE9"/>
</svg>
SVGEOF

# Server
cat > images/stencils/devices/server.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" viewBox="0 0 60 60">
  <rect x="15" y="5" width="30" height="50" rx="2" ry="2" fill="#455A64" stroke="#263238" stroke-width="2"/>
  <rect x="20" y="10" width="20" height="5" rx="1" ry="1" fill="#B0BEC5" stroke="#78909C" stroke-width="1"/>
  <rect x="20" y="20" width="20" height="5" rx="1" ry="1" fill="#B0BEC5" stroke="#78909C" stroke-width="1"/>
  <rect x="20" y="30" width="20" height="5" rx="1" ry="1" fill="#B0BEC5" stroke="#78909C" stroke-width="1"/>
  <rect x="20" y="40" width="20" height="5" rx="1" ry="1" fill="#B0BEC5" stroke="#78909C" stroke-width="1"/>
  <circle cx="25" cy="12.5" r="1.5" fill="#F44336"/>
  <circle cx="25" cy="22.5" r="1.5" fill="#4CAF50"/>
  <circle cx="25" cy="32.5" r="1.5" fill="#4CAF50"/>
  <circle cx="25" cy="42.5" r="1.5" fill="#4CAF50"/>
</svg>
SVGEOF

# Printer
cat > images/stencils/devices/printer.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" viewBox="0 0 60 60">
  <rect x="10" y="20" width="40" height="25" rx="2" ry="2" fill="#78909C" stroke="#37474F" stroke-width="2"/>
  <rect x="15" y="12" width="30" height="8" fill="#CFD8DC" stroke="#37474F" stroke-width="1"/>
  <rect x="15" y="45" width="30" height="8" fill="#CFD8DC" stroke="#37474F" stroke-width="1"/>
  <rect x="20" y="25" width="20" height="15" fill="#ECEFF1"/>
  <circle cx="40" cy="30" r="3" fill="#4CAF50"/>
</svg>
SVGEOF

# Camera
cat > images/stencils/devices/camera.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" viewBox="0 0 60 60">
  <rect x="10" y="20" width="30" height="20" rx="2" ry="2" fill="#455A64" stroke="#263238" stroke-width="2"/>
  <circle cx="25" cy="30" r="8" fill="#78909C" stroke="#263238" stroke-width="1"/>
  <circle cx="25" cy="30" r="4" fill="#CFD8DC"/>
  <path d="M40,25 L50,20 L50,40 L40,35 Z" fill="#455A64" stroke="#263238" stroke-width="2"/>
</svg>
SVGEOF

# Create authentication method icons
echo -e "${YELLOW}Creating authentication method icons...${NC}"

# EAP-TLS icon
cat > images/stencils/authentication/eap_tls.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="100" height="60" viewBox="0 0 100 60">
  <rect x="5" y="5" width="90" height="50" rx="5" ry="5" fill="#FDD835" stroke="#F57F17" stroke-width="2"/>
  <text x="50" y="35" font-family="Arial" font-size="14" text-anchor="middle" fill="#000">EAP-TLS</text>
</svg>
SVGEOF

# EAP-TTLS icon
cat > images/stencils/authentication/eap_ttls.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="100" height="60" viewBox="0 0 100 60">
  <rect x="5" y="5" width="90" height="50" rx="5" ry="5" fill="#FFB300" stroke="#E65100" stroke-width="2"/>
  <text x="50" y="35" font-family="Arial" font-size="14" text-anchor="middle" fill="#000">EAP-TTLS</text>
</svg>
SVGEOF

# PEAP icon
cat > images/stencils/authentication/peap.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="100" height="60" viewBox="0 0 100 60">
  <rect x="5" y="5" width="90" height="50" rx="5" ry="5" fill="#FFA000" stroke="#E65100" stroke-width="2"/>
  <text x="50" y="35" font-family="Arial" font-size="14" text-anchor="middle" fill="#000">PEAP</text>
</svg>
SVGEOF

# EAP-FAST icon
cat > images/stencils/authentication/eap_fast.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="100" height="60" viewBox="0 0 100 60">
  <rect x="5" y="5" width="90" height="50" rx="5" ry="5" fill="#FF8F00" stroke="#EF6C00" stroke-width="2"/>
  <text x="50" y="35" font-family="Arial" font-size="14" text-anchor="middle" fill="#000">EAP-FAST</text>
</svg>
SVGEOF

# MAB icon
cat > images/stencils/authentication/mab.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="100" height="60" viewBox="0 0 100 60">
  <rect x="5" y="5" width="90" height="50" rx="5" ry="5" fill="#FF9800" stroke="#E65100" stroke-width="2"/>
  <text x="50" y="35" font-family="Arial" font-size="14" text-anchor="middle" fill="#000">MAB</text>
</svg>
SVGEOF

# WebAuth icon
cat > images/stencils/authentication/webauth.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="100" height="60" viewBox="0 0 100 60">
  <rect x="5" y="5" width="90" height="50" rx="5" ry="5" fill="#2196F3" stroke="#1565C0" stroke-width="2"/>
  <text x="50" y="35" font-family="Arial" font-size="14" text-anchor="middle" fill="#FFFFFF">WebAuth</text>
</svg>
SVGEOF

# Create Portnox product icons
echo -e "${YELLOW}Creating Portnox product icons...${NC}"

# Portnox Cloud icon
cat > images/stencils/portnox/portnox_cloud.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="100" height="60" viewBox="0 0 100 60">
  <rect x="5" y="5" width="90" height="50" rx="5" ry="5" fill="#1E88E5" stroke="#0D47A1" stroke-width="2"/>
  <text x="50" y="35" font-family="Arial" font-size="12" text-anchor="middle" fill="white">Portnox Cloud</text>
</svg>
SVGEOF

# Portnox RADIUS Server icon
cat > images/stencils/portnox/portnox_radius.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="100" height="60" viewBox="0 0 100 60">
  <rect x="5" y="5" width="90" height="50" rx="5" ry="5" fill="#43A047" stroke="#1B5E20" stroke-width="2"/>
  <text x="50" y="30" font-family="Arial" font-size="12" text-anchor="middle" fill="white">Portnox</text>
  <text x="50" y="45" font-family="Arial" font-size="12" text-anchor="middle" fill="white">RADIUS</text>
</svg>
SVGEOF

# Portnox Clear icon
cat > images/stencils/portnox/portnox_clear.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="100" height="60" viewBox="0 0 100 60">
  <rect x="5" y="5" width="90" height="50" rx="5" ry="5" fill="#7B1FA2" stroke="#4A148C" stroke-width="2"/>
  <text x="50" y="30" font-family="Arial" font-size="12" text-anchor="middle" fill="white">Portnox</text>
  <text x="50" y="45" font-family="Arial" font-size="12" text-anchor="middle" fill="white">Clear</text>
</svg>
SVGEOF

# Portnox Core icon
cat > images/stencils/portnox/portnox_core.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="100" height="60" viewBox="0 0 100 60">
  <rect x="5" y="5" width="90" height="50" rx="5" ry="5" fill="#E65100" stroke="#BF360C" stroke-width="2"/>
  <text x="50" y="30" font-family="Arial" font-size="12" text-anchor="middle" fill="white">Portnox</text>
  <text x="50" y="45" font-family="Arial" font-size="12" text-anchor="middle" fill="white">Core</text>
</svg>
SVGEOF

# Create cloud service icons
echo -e "${YELLOW}Creating cloud service icons...${NC}"

# Azure AD icon
cat > images/stencils/cloud/azure/active_directory.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" viewBox="0 0 60 60">
  <rect x="10" y="10" width="40" height="40" rx="4" ry="4" fill="#0078D4" stroke="#005A9E" stroke-width="2"/>
  <text x="30" y="27" font-family="Arial" font-size="8" text-anchor="middle" fill="white">Azure</text>
  <text x="30" y="38" font-family="Arial" font-size="8" text-anchor="middle" fill="white">AD</text>
</svg>
SVGEOF

# Certificate icon
cat > images/stencils/certificates/certificate.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" viewBox="0 0 60 60">
  <rect x="10" y="15" width="40" height="30" rx="2" ry="2" fill="#FFECB3" stroke="#FFA000" stroke-width="2"/>
  <path d="M15,25 L45,25" stroke="#FFA000" stroke-width="1"/>
  <path d="M15,30 L45,30" stroke="#FFA000" stroke-width="1"/>
  <path d="M15,35 L35,35" stroke="#FFA000" stroke-width="1"/>
  <circle cx="40" cy="37" r="7" fill="#FFC107" stroke="#FFA000" stroke-width="1"/>
</svg>
SVGEOF

# Create certificate authority icon
cat > images/stencils/certificates/ca.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" viewBox="0 0 60 60">
  <rect x="10" y="15" width="40" height="30" rx="2" ry="2" fill="#FFECB3" stroke="#FF6F00" stroke-width="2"/>
  <path d="M15,25 L45,25" stroke="#FF6F00" stroke-width="1"/>
  <path d="M15,30 L45,30" stroke="#FF6F00" stroke-width="1"/>
  <path d="M15,35 L35,35" stroke="#FF6F00" stroke-width="1"/>
  <circle cx="40" cy="37" r="7" fill="#FF9800" stroke="#FF6F00" stroke-width="1"/>
  <text x="40" y="40" font-family="Arial" font-size="8" font-weight="bold" text-anchor="middle" fill="white">CA</text>
</svg>
SVGEOF

# Create smart card icon
cat > images/stencils/certificates/smart_card.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" viewBox="0 0 60 60">
  <rect x="10" y="15" width="40" height="30" rx="2" ry="2" fill="#FFE0B2" stroke="#FF6F00" stroke-width="2"/>
  <rect x="15" y="25" width="15" height="15" rx="2" ry="2" fill="#FFB74D" stroke="#FF6F00" stroke-width="1"/>
  <rect x="35" y="25" width="10" height="3" rx="1" ry="1" fill="#FFB74D" stroke="#FF6F00" stroke-width="1"/>
  <rect x="35" y="31" width="10" height="3" rx="1" ry="1" fill="#FFB74D" stroke="#FF6F00" stroke-width="1"/>
  <rect x="35" y="37" width="10" height="3" rx="1" ry="1" fill="#FFB74D" stroke="#FF6F00" stroke-width="1"/>
</svg>
SVGEOF

# Create security icons
echo -e "${YELLOW}Creating security icons...${NC}"

# MFA icon
cat > images/stencils/security/mfa.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" viewBox="0 0 60 60">
  <circle cx="30" cy="30" r="20" fill="#E1BEE7" stroke="#8E24AA" stroke-width="2"/>
  <rect x="22" y="20" width="16" height="20" rx="2" ry="2" fill="#9C27B0" stroke="#6A1B9A" stroke-width="1.5"/>
  <circle cx="30" cy="30" r="3" fill="#E1BEE7"/>
  <rect x="29" y="30" width="2" height="5" fill="#E1BEE7"/>
  <text x="30" y="15" font-family="Arial" font-size="7" font-weight="bold" text-anchor="middle" fill="#6A1B9A">MFA</text>
</svg>
SVGEOF

# Splunk icon
cat > images/stencils/security/splunk.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" viewBox="0 0 60 60">
  <rect x="10" y="15" width="40" height="30" rx="3" ry="3" fill="#5CC85C" stroke="#289428" stroke-width="2"/>
  <text x="30" y="35" font-family="Arial" font-size="10" font-weight="bold" text-anchor="middle" fill="white">SPLUNK</text>
</svg>
SVGEOF

# Sentinel icon
cat > images/stencils/security/sentinel.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" viewBox="0 0 60 60">
  <rect x="10" y="15" width="40" height="30" rx="3" ry="3" fill="#0078D4" stroke="#005A9E" stroke-width="2"/>
  <text x="30" y="33" font-family="Arial" font-size="8" font-weight="bold" text-anchor="middle" fill="white">SENTINEL</text>
</svg>
SVGEOF

# Create service icons
echo -e "${YELLOW}Creating service icons...${NC}"

# ServiceNow icon
cat > images/stencils/services/servicenow.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" viewBox="0 0 60 60">
  <rect x="10" y="15" width="40" height="30" rx="3" ry="3" fill="#81B5A1" stroke="#5A8074" stroke-width="2"/>
  <text x="30" y="35" font-family="Arial" font-size="8" font-weight="bold" text-anchor="middle" fill="white">ServiceNow</text>
</svg>
SVGEOF

# Jira icon
cat > images/stencils/services/jira.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" viewBox="0 0 60 60">
  <rect x="10" y="15" width="40" height="30" rx="3" ry="3" fill="#0052CC" stroke="#003580" stroke-width="2"/>
  <text x="30" y="35" font-family="Arial" font-size="10" font-weight="bold" text-anchor="middle" fill="white">JIRA</text>
</svg>
SVGEOF

# Create network icons
echo -e "${YELLOW}Creating network icons...${NC}"

# Building icon
cat > images/stencils/network/building.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" viewBox="0 0 60 60">
  <rect x="10" y="5" width="40" height="50" fill="#ECEFF1" stroke="#90A4AE" stroke-width="2"/>
  <rect x="15" y="10" width="10" height="10" fill="#B0BEC5" stroke="#90A4AE" stroke-width="1"/>
  <rect x="35" y="10" width="10" height="10" fill="#B0BEC5" stroke="#90A4AE" stroke-width="1"/>
  <rect x="15" y="25" width="10" height="10" fill="#B0BEC5" stroke="#90A4AE" stroke-width="1"/>
  <rect x="35" y="25" width="10" height="10" fill="#B0BEC5" stroke="#90A4AE" stroke-width="1"/>
  <rect x="15" y="40" width="10" height="10" fill="#B0BEC5" stroke="#90A4AE" stroke-width="1"/>
  <rect x="35" y="40" width="10" height="10" fill="#B0BEC5" stroke="#90A4AE" stroke-width="1"/>
</svg>
SVGEOF

# Create XML stencil definitions
echo -e "${YELLOW}Creating stencil definitions...${NC}"

# Portnox stencil definition
cat > js/diagrams/stencils/portnox.xml << 'EOL'
<shapes name="Portnox">
  <shape name="Portnox Cloud" aspect="fixed" strokewidth="2">
    <foreground>
      <image src="images/stencils/portnox/portnox_cloud.svg" width="100" height="60"/>
    </foreground>
  </shape>
  <shape name="Portnox RADIUS" aspect="fixed" strokewidth="2">
    <foreground>
      <image src="images/stencils/portnox/portnox_radius.svg" width="100" height="60"/>
    </foreground>
  </shape>
  <shape name="Portnox Clear" aspect="fixed" strokewidth="2">
    <foreground>
      <image src="images/stencils/portnox/portnox_clear.svg" width="100" height="60"/>
    </foreground>
  </shape>
  <shape name="Portnox Core" aspect="fixed" strokewidth="2">
    <foreground>
      <image src="images/stencils/portnox/portnox_core.svg" width="100" height="60"/>
    </foreground>
  </shape>
</shapes>
EOL

# Authentication methods stencil definition
cat > js/diagrams/stencils/authentication.xml << 'EOL'
<shapes name="Authentication Methods">
  <shape name="EAP-TLS" aspect="fixed" strokewidth="2">
    <foreground>
      <image src="images/stencils/authentication/eap_tls.svg" width="100" height="60"/>
    </foreground>
  </shape>
  <shape name="EAP-TTLS" aspect="fixed" strokewidth="2">
    <foreground>
      <image src="images/stencils/authentication/eap_ttls.svg" width="100" height="60"/>
    </foreground>
  </shape>
  <shape name="PEAP" aspect="fixed" strokewidth="2">
    <foreground>
      <image src="images/stencils/authentication/peap.svg" width="100" height="60"/>
    </foreground>
  </shape>
  <shape name="EAP-FAST" aspect="fixed" strokewidth="2">
    <foreground>
      <image src="images/stencils/authentication/eap_fast.svg" width="100" height="60"/>
    </foreground>
  </shape>
  <shape name="MAB" aspect="fixed" strokewidth="2">
    <foreground>
      <image src="images/stencils/authentication/mab.svg" width="100" height="60"/>
    </foreground>
  </shape>
  <shape name="WebAuth" aspect="fixed" strokewidth="2">
    <foreground>
      <image src="images/stencils/authentication/webauth.svg" width="100" height="60"/>
    </foreground>
  </shape>
</shapes>
EOL

# Devices stencil definition
cat > js/diagrams/stencils/devices.xml << 'EOL'
<shapes name="Devices">
  <shape name="BYOD Device" aspect="fixed" strokewidth="2">
    <foreground>
      <image src="images/stencils/devices/byod.svg" width="60" height="60"/>
    </foreground>
  </shape>
  <shape name="IoT Device" aspect="fixed" strokewidth="2">
    <foreground>
      <image src="images/stencils/devices/iot.svg" width="60" height="60"/>
    </foreground>
  </shape>
  <shape name="Desktop" aspect="fixed" strokewidth="2">
    <foreground>
      <image src="images/stencils/devices/desktop.svg" width="60" height="60"/>
    </foreground>
  </shape>
  <shape name="Phone" aspect="fixed" strokewidth="2">
    <foreground>
      <image src="images/stencils/devices/phone.svg" width="60" height="60"/>
    </foreground>
  </shape>
  <shape name="Server" aspect="fixed" strokewidth="2">
    <foreground>
      <image src="images/stencils/devices/server.svg" width="60" height="60"/>
    </foreground>
  </shape>
  <shape name="Printer" aspect="fixed" strokewidth="2">
    <foreground>
      <image src="images/stencils/devices/printer.svg" width="60" height="60"/>
    </foreground>
  </shape>
  <shape name="Camera" aspect="fixed" strokewidth="2">
    <foreground>
      <image src="images/stencils/devices/camera.svg" width="60" height="60"/>
    </foreground>
  </shape>
</shapes>
EOL

# Vendor stencil definition
cat > js/diagrams/stencils/vendors.xml << 'EOL'
<shapes name="Vendors">
  <shape name="Cisco Switch" aspect="fixed" strokewidth="2">
    <foreground>
      <image src="images/stencils/vendors/cisco/switch.svg" width="60" height="60"/>
    </foreground>
  </shape>
  <shape name="Cisco Router" aspect="fixed" strokewidth="2">
    <foreground>
      <image src="images/stencils/vendors/cisco/router.svg" width="60" height="60"/>
    </foreground>
  </shape>
  <shape name="Cisco Firewall" aspect="fixed" strokewidth="2">
    <foreground>
      <image src="images/stencils/vendors/cisco/firewall.svg" width="60" height="60"/>
    </foreground>
  </shape>
  <shape name="Cisco Wireless AP" aspect="fixed" strokewidth="2">
    <foreground>
      <image src="images/stencils/vendors/cisco/wireless_ap.svg" width="60" height="60"/>
    </foreground>
  </shape>
  <shape name="Aruba Switch" aspect="fixed" strokewidth="2">
    <foreground>
      <image src="images/stencils/vendors/aruba/switch.svg" width="60" height="60"/>
    </foreground>
  </shape>
  <shape name="Aruba Wireless AP" aspect="fixed" strokewidth="2">
    <foreground>
      <image src="images/stencils/vendors/aruba/wireless_ap.svg" width="60" height="60"/>
    </foreground>
  </shape>
  <shape name="Juniper Switch" aspect="fixed" strokewidth="2">
    <foreground>
      <image src="images/stencils/vendors/juniper/switch.svg" width="60" height="60"/>
    </foreground>
  </shape>
  <shape name="Juniper Router" aspect="fixed" strokewidth="2">
    <foreground>
      <image src="images/stencils/vendors/juniper/router.svg" width="60" height="60"/>
    </foreground>
  </shape>
  <shape name="Palo Alto Firewall" aspect="fixed" strokewidth="2">
    <foreground>
      <image src="images/stencils/vendors/paloalto/firewall.svg" width="60" height="60"/>
    </foreground>
  </shape>
  <shape name="Fortinet Firewall" aspect="fixed" strokewidth="2">
    <foreground>
      <image src="images/stencils/vendors/fortinet/firewall.svg" width="60" height="60"/>
    </foreground>
  </shape>
</shapes>
EOL

# Cloud services stencil definition
cat > js/diagrams/stencils/cloud_services.xml << 'EOL'
<shapes name="Cloud Services">
  <shape name="Azure AD" aspect="fixed" strokewidth="2">
    <foreground>
      <image src="images/stencils/cloud/azure/active_directory.svg" width="60" height="60"/>
    </foreground>
  </shape>
  <shape name="Certificate" aspect="fixed" strokewidth="2">
    <foreground>
      <image src="images/stencils/certificates/certificate.svg" width="60" height="60"/>
    </foreground>
  </shape>
  <shape name="Certificate Authority" aspect="fixed" strokewidth="2">
    <foreground>
      <image src="images/stencils/certificates/ca.svg" width="60" height="60"/>
    </foreground>
  </shape>
  <shape name="Smart Card" aspect="fixed" strokewidth="2">
    <foreground>
      <image src="images/stencils/certificates/smart_card.svg" width="60" height="60"/>
    </foreground>
  </shape>
  <shape name="MFA" aspect="fixed" strokewidth="2">
    <foreground>
      <image src="images/stencils/security/mfa.svg" width="60" height="60"/>
    </foreground>
  </shape>
  <shape name="ServiceNow" aspect="fixed" strokewidth="2">
    <foreground>
      <image src="images/stencils/services/servicenow.svg" width="60" height="60"/>
    </foreground>
  </shape>
  <shape name="Jira" aspect="fixed" strokewidth="2">
    <foreground>
      <image src="images/stencils/services/jira.svg" width="60" height="60"/>
    </foreground>
  </shape>
</shapes>
EOL

# Create integration script
echo -e "${YELLOW}Creating integration script...${NC}"
cat > portnox_diagrams_integration.sh << 'EOL'
#!/bin/bash

# Portnox Cloud NAC Diagrams Integration Script
# This script updates index.html and tests the integration

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}====================================================${NC}"
echo -e "${BLUE}  Portnox NAC Diagram Integration - Final Setup     ${NC}"
echo -e "${BLUE}====================================================${NC}"

# Update index.html if it exists
if [ -f "index.html" ]; then
    echo -e "${YELLOW}Updating index.html with diagram resources...${NC}"
    echo -e "${BLUE}Backing up original index.html to index.html.bak${NC}"
    cp index.html "index.html.bak.$(date +%Y%m%d%H%M%S)"
    
    # Inject CSS links
    if ! grep -q "css/diagrams/diagram-styles.css" index.html; then
        echo -e "${BLUE}Adding diagram CSS links to head section${NC}"
        sed -i -e '/<\/head>/ i\
    <!-- Portnox Diagram Styles -->\
    <link href="css/diagrams/diagram-styles.css" rel="stylesheet">' index.html
    fi
    
    # Inject JS scripts
    if ! grep -q "js/diagrams/mxClient.js" index.html; then
        echo -e "${BLUE}Adding diagram JS scripts before body end${NC}"
        sed -i -e '/<\/body>/ i\
    <!-- Portnox NAC Diagram Libraries -->\
    <script src="js/diagrams/mxClient.js"></script>\
    <script src="js/diagrams/diagram-generator.js"></script>\
    <script src="js/diagrams/diagram-ui.js"></script>\
    <script>\
      document.addEventListener("DOMContentLoaded", function() {\
        if (typeof PortnoxDiagramUI !== "undefined") {\
          PortnoxDiagramUI.initialize();\
        }\
      });\
    </script>' index.html
    fi
    
    echo -e "${GREEN}Successfully updated index.html${NC}"
else
    echo -e "${YELLOW}index.html not found. Skipping update.${NC}"
fi

# Test if the key files exist
echo -e "${YELLOW}Verifying installation...${NC}"

FILES_OK=true
for file in js/diagrams/mxClient.js js/diagrams/diagram-generator.js js/diagrams/diagram-ui.js css/diagrams/diagram-styles.css; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}Missing file: $file${NC}"
        FILES_OK=false
    fi
done

if [ "$FILES_OK" = true ]; then
    echo -e "${GREEN}All required files are present.${NC}"
else
    echo -e "${RED}Some required files are missing. Installation may be incomplete.${NC}"
fi

# Verify stencil directories
echo -e "${YELLOW}Checking stencil directories...${NC}"
STENCIL_DIRS_OK=true

for dir in images/stencils/vendors images/stencils/portnox images/stencils/devices images/stencils/authentication; do
    if [ ! -d "$dir" ]; then
        echo -e "${RED}Missing directory: $dir${NC}"
        STENCIL_DIRS_OK=false
    else
        # Check if directory has any files
        if [ -z "$(ls -A $dir 2>/dev/null)" ]; then
            echo -e "${YELLOW}Warning: Directory $dir is empty${NC}"
        fi
    fi
done

if [ "$STENCIL_DIRS_OK" = true ]; then
    echo -e "${GREEN}All stencil directories are present.${NC}"
else
    echo -e "${RED}Some stencil directories are missing. Installation may be incomplete.${NC}"
fi

# Create a test page
if [ ! -f "test_portnox_diagrams.html" ]; then
    echo -e "${YELLOW}Creating a test page for Portnox diagrams...${NC}"
    
    cat > test_portnox_diagrams.html << 'HTMLEOF'
<!DOCTYPE html>
<html>
<head>
    <title>Portnox Cloud NAC Diagrams</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="css/diagrams/diagram-styles.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            color: #333;
            background-color: #f8f9fa;
        }
        h1, h2 {
            color: #0078D4;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-control {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .btn {
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
        }
        .btn-primary {
            background-color: #0078D4;
            color: white;
            border: none;
        }
        .card {
            background-color: white;
            border-radius: 4px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .card-header {
            padding: 15px;
            border-bottom: 1px solid #ddd;
            font-weight: bold;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .card-body {
            padding: 20px;
        }
        .row {
            display: flex;
            flex-wrap: wrap;
            margin: -10px;
        }
        .col-md-6, .col-md-4, .col-md-3 {
            padding: 10px;
            box-sizing: border-box;
        }
        .col-md-6 {
            width: 50%;
        }
        .col-md-4 {
            width: 33.333333%;
        }
        .col-md-3 {
            width: 25%;
        }
        @media (max-width: 768px) {
            .col-md-6, .col-md-4, .col-md-3 {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Portnox Cloud NAC Diagrams</h1>
        <p>Interactive network diagrams for Portnox Cloud NAC deployment scenarios.</p>
        
        <div class="card">
            <div class="card-header">
                <h2 style="margin: 0;">Network Diagrams</h2>
                <button type="button" class="btn btn-primary" id="toggle-options">
                    <i class="fas fa-cog"></i> Options
                </button>
            </div>
            <div class="card-body">
                <div id="diagram-options">
                    <div class="row">
                        <div class="col-md-6">
                            <h3>Diagram Type</h3>
                            <div class="form-group">
                                <select class="form-control" id="diagram-type">
                                    <optgroup label="Deployment Scenarios">
                                        <option value="basic_cloud_deployment">Basic Cloud Deployment</option>
                                        <option value="enterprise_deployment">Enterprise Deployment</option>
                                        <option value="multi_vendor_deployment">Multi-Vendor Deployment</option>
                                        <option value="high_security_deployment">High Security Deployment</option>
                                        <option value="cloud_integration">Cloud Service Integration</option>
                                        <option value="multi_site_deployment">Multi-Site Deployment</option>
                                    </optgroup>
                                    <optgroup label="Industry Specific">
                                        <option value="healthcare_deployment">Healthcare Deployment</option>
                                        <option value="education_deployment">Education Deployment</option>
                                        <option value="retail_deployment">Retail Deployment</option>
                                        <option value="manufacturing_deployment">Manufacturing Deployment</option>
                                        <option value="government_deployment">Government Deployment</option>
                                        <option value="financial_deployment">Financial Services Deployment</option>
                                    </optgroup>
                                    <optgroup label="Authentication & Workflows">
                                        <option value="eap_tls_authentication">EAP-TLS Authentication Flow</option>
                                        <option value="byod_onboarding">BYOD Onboarding Flow</option>
                                        <option value="guest_access">Guest Access Portal</option>
                                        <option value="dynamic_vlan_assignment">Dynamic VLAN Assignment</option>
                                        <option value="iot_segmentation">IoT Segmentation</option>
                                    </optgroup>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="vendor-select">Network Equipment Vendor</label>
                                <select class="form-control" id="vendor-select">
                                    <option value="cisco">Cisco</option>
                                    <option value="aruba">Aruba</option>
                                    <option value="juniper">Juniper</option>
                                    <option value="extreme">Extreme</option>
                                    <option value="fortinet">Fortinet</option>
                                    <option value="paloalto">Palo Alto</option>
                                    <option value="hp">HP Enterprise</option>
                                    <option value="dell">Dell</option>
                                    <option value="arista">Arista</option>
                                </select>
                            </div>
                            <button id="generate-diagram-btn" class="btn btn-primary">
                                <i class="fas fa-project-diagram"></i> Generate Diagram
                            </button>
                        </div>
                        <div class="col-md-6">
                            <h3>Diagram Components</h3>
                            <div style="margin-bottom: 10px;">
                                <input type="checkbox" id="show-radius" checked>
                                <label for="show-radius">Show RADIUS Server</label>
                            </div>
                            <div style="margin-bottom: 10px;">
                                <input type="checkbox" id="show-auth" checked>
                                <label for="show-auth">Show Authentication Methods</label>
                            </div>
                            <div style="margin-bottom: 10px;">
                                <input type="checkbox" id="show-clients" checked>
                                <label for="show-clients">Show Client Devices</label>
                            </div>
                            <div style="margin-bottom: 10px;">
                                <input type="checkbox" id="show-cloud" checked>
                                <label for="show-cloud">Show Cloud Services</label>
                            </div>
                            <div style="margin-bottom: 10px;">
                                <input type="checkbox" id="show-legends" checked>
                                <label for="show-legends">Show Legends & Notes</label>
                            </div>
                            <div style="margin-bottom: 10px;">
                                <input type="checkbox" id="show-detailed" checked>
                                <label for="show-detailed">Show Detailed Components</label>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div id="diagram-status" class="alert" style="display: none; padding: 10px; margin: 15px 0; border-radius: 4px;"></div>
                
                <div id="diagram-container" class="diagram-container" style="display: none;">
                    <div class="diagram-toolbar">
                        <button id="zoom-in-btn" title="Zoom In">
                            <i class="fas fa-search-plus"></i>
                        </button>
                        <button id="zoom-out-btn" title="Zoom Out">
                            <i class="fas fa-search-minus"></i>
                        </button>
                        <button id="zoom-reset-btn" title="Reset Zoom">
                            <i class="fas fa-compress"></i>
                        </button>
                        <span class="toolbar-separator"></span>
                        <button id="export-png-btn" title="Export as PNG">
                            <i class="fas fa-file-image"></i> PNG
                        </button>
                        <button id="export-svg-btn" title="Export as SVG">
                            <i class="fas fa-file-code"></i> SVG
                        </button>
                    </div>
                    <div id="diagram-canvas" class="diagram-canvas"></div>
                </div>
                
                <h3 style="margin-top: 20px;">Recommended Diagrams</h3>
                <div class="row">
                    <div class="col-md-4">
                        <div class="template-card" data-template="basic_cloud_deployment">
                            <div class="template-thumbnail">
                                <i class="fas fa-network-wired"></i>
                            </div>
                            <div class="template-title">Basic Cloud Deployment</div>
                            <div class="template-description">Standard Portnox Cloud NAC deployment</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="template-card" data-template="eap_tls_authentication">
                            <div class="template-thumbnail">
                                <i class="fas fa-key"></i>
                            </div>
                            <div class="template-title">EAP-TLS Authentication</div>
                            <div class="template-description">Certificate-based authentication flow</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="template-card" data-template="dynamic_vlan_assignment">
                            <div class="template-thumbnail">
                                <i class="fas fa-project-diagram"></i>
                            </div>
                            <div class="template-title">Dynamic VLAN Assignment</div>
                            <div class="template-description">Role and device-based segmentation</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Load diagram libraries -->
    <script src="js/diagrams/mxClient.js"></script>
    <script src="js/diagrams/diagram-generator.js"></script>
    <script src="js/diagrams/diagram-ui.js"></script>
    <script>
        // Initialize diagram UI
        document.addEventListener('DOMContentLoaded', function() {
            // Initialize UI
            if (typeof PortnoxDiagramUI !== 'undefined') {
                PortnoxDiagramUI.initialize();
            }
            
            // Toggle options panel
            const toggleBtn = document.getElementById('toggle-options');
            const optionsPanel = document.getElementById('diagram-options');
            
            if (toggleBtn && optionsPanel) {
                toggleBtn.addEventListener('click', function() {
                    if (optionsPanel.style.display === 'none') {
                        optionsPanel.style.display = 'block';
                        toggleBtn.innerHTML = '<i class="fas fa-times"></i> Hide Options';
                    } else {
                        optionsPanel.style.display = 'none';
                        toggleBtn.innerHTML = '<i class="fas fa-cog"></i> Options';
                    }
                });
            }
        });
    </script>
</body>
</html>
HTMLEOF

    echo -e "${GREEN}Test page created: test_portnox_diagrams.html${NC}"
fi

echo -e "${GREEN}Integration complete! To test the diagrams, open:${NC}"
echo -e "${BLUE}test_portnox_diagrams.html${NC}"

echo -e "\n${YELLOW}What to do next:${NC}"
echo -e "1. Open the test page to verify diagram functionality"
echo -e "2. Check that all icons and stencils are working properly"
echo -e "3. Try generating and exporting diagrams for different scenarios"
echo -e "4. Review industry-specific deployments for your environment"

echo -e "\n${GREEN}For any issues, check the browser console for error messages${NC}"
EOL
chmod +x portnox_diagrams_integration.sh

# Create test HTML page
echo -e "${YELLOW}Creating test HTML page for Portnox diagrams...${NC}"
cat > test_portnox_diagrams.html << 'EOL'
<!DOCTYPE html>
<html>
<head>
    <title>Portnox Cloud NAC Diagrams</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="css/diagrams/diagram-styles.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            color: #333;
            background-color: #f8f9fa;
        }
        h1, h2 {
            color: #0078D4;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-control {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .btn {
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
        }
        .btn-primary {
            background-color: #0078D4;
            color: white;
            border: none;
        }
        .card {
            background-color: white;
            border-radius: 4px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .card-header {
            padding: 15px;
            border-bottom: 1px solid #ddd;
            font-weight: bold;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .card-body {
            padding: 20px;
        }
        .row {
            display: flex;
            flex-wrap: wrap;
            margin: -10px;
        }
        .col-md-6, .col-md-4, .col-md-3 {
            padding: 10px;
            box-sizing: border-box;
        }
        .col-md-6 {
            width: 50%;
        }
        .col-md-4 {
            width: 33.333333%;
        }
        .col-md-3 {
            width: 25%;
        }
        @media (max-width: 768px) {
            .col-md-6, .col-md-4, .col-md-3 {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Portnox Cloud NAC Diagrams</h1>
        <p>Interactive network diagrams for Portnox Cloud NAC deployment scenarios.</p>
        
        <div class="card">
            <div class="card-header">
                <h2 style="margin: 0;">Network Diagrams</h2>
                <button type="button" class="btn btn-primary" id="toggle-options">
                    <i class="fas fa-cog"></i> Options
                </button>
            </div>
            <div class="card-body">
                <div id="diagram-options">
                    <div class="row">
                        <div class="col-md-6">
                            <h3>Diagram Type</h3>
                            <div class="form-group">
                                <select class="form-control" id="diagram-type">
                                    <optgroup label="Deployment Scenarios">
                                        <option value="basic_cloud_deployment">Basic Cloud Deployment</option>
                                        <option value="enterprise_deployment">Enterprise Deployment</option>
                                        <option value="multi_vendor_deployment">Multi-Vendor Deployment</option>
                                        <option value="high_security_deployment">High Security Deployment</option>
                                        <option value="cloud_integration">Cloud Service Integration</option>
                                        <option value="multi_site_deployment">Multi-Site Deployment</option>
                                    </optgroup>
                                    <optgroup label="Industry Specific">
                                        <option value="healthcare_deployment">Healthcare Deployment</option>
                                        <option value="education_deployment">Education Deployment</option>
                                        <option value="retail_deployment">Retail Deployment</option>
                                        <option value="manufacturing_deployment">Manufacturing Deployment</option>
                                        <option value="government_deployment">Government Deployment</option>
                                        <option value="financial_deployment">Financial Services Deployment</option>
                                    </optgroup>
                                    <optgroup label="Authentication & Workflows">
                                        <option value="eap_tls_authentication">EAP-TLS Authentication Flow</option>
                                        <option value="byod_onboarding">BYOD Onboarding Flow</option>
                                        <option value="guest_access">Guest Access Portal</option>
                                        <option value="dynamic_vlan_assignment">Dynamic VLAN Assignment</option>
                                        <option value="iot_segmentation">IoT Segmentation</option>
                                    </optgroup>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="vendor-select">Network Equipment Vendor</label>
                                <select class="form-control" id="vendor-select">
                                    <option value="cisco">Cisco</option>
                                    <option value="aruba">Aruba</option>
                                    <option value="juniper">Juniper</option>
                                    <option value="extreme">Extreme</option>
                                    <option value="fortinet">Fortinet</option>
                                    <option value="paloalto">Palo Alto</option>
                                    <option value="hp">HP Enterprise</option>
                                    <option value="dell">Dell</option>
                                    <option value="arista">Arista</option>
                                </select>
                            </div>
                            <button id="generate-diagram-btn" class="btn btn-primary">
                                <i class="fas fa-project-diagram"></i> Generate Diagram
                            </button>
                        </div>
                        <div class="col-md-6">
                            <h3>Diagram Components</h3>
                            <div style="margin-bottom: 10px;">
                                <input type="checkbox" id="show-radius" checked>
                                <label for="show-radius">Show RADIUS Server</label>
                            </div>
                            <div style="margin-bottom: 10px;">
                                <input type="checkbox" id="show-auth" checked>
                                <label for="show-auth">Show Authentication Methods</label>
                            </div>
                            <div style="margin-bottom: 10px;">
                                <input type="checkbox" id="show-clients" checked>
                                <label for="show-clients">Show Client Devices</label>
                            </div>
                            <div style="margin-bottom: 10px;">
                                <input type="checkbox" id="show-cloud" checked>
                                <label for="show-cloud">Show Cloud Services</label>
                            </div>
                            <div style="margin-bottom: 10px;">
                                <input type="checkbox" id="show-legends" checked>
                                <label for="show-legends">Show Legends & Notes</label>
                            </div>
                            <div style="margin-bottom: 10px;">
                                <input type="checkbox" id="show-detailed" checked>
                                <label for="show-detailed">Show Detailed Components</label>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div id="diagram-status" class="alert" style="display: none; padding: 10px; margin: 15px 0; border-radius: 4px;"></div>
                
                <div id="diagram-container" class="diagram-container" style="display: none;">
                    <div class="diagram-toolbar">
                        <button id="zoom-in-btn" title="Zoom In">
                            <i class="fas fa-search-plus"></i>
                        </button>
                        <button id="zoom-out-btn" title="Zoom Out">
                            <i class="fas fa-search-minus"></i>
                        </button>
                        <button id="zoom-reset-btn" title="Reset Zoom">
                            <i class="fas fa-compress"></i>
                        </button>
                        <span class="toolbar-separator"></span>
                        <button id="export-png-btn" title="Export as PNG">
                            <i class="fas fa-file-image"></i> PNG
                        </button>
                        <button id="export-svg-btn" title="Export as SVG">
                            <i class="fas fa-file-code"></i> SVG
                        </button>
                    </div>
                    <div id="diagram-canvas" class="diagram-canvas"></div>
                </div>
                
                <h3 style="margin-top: 20px;">Recommended Diagrams</h3>
                <div class="row">
                    <div class="col-md-4">
                        <div class="template-card" data-template="basic_cloud_deployment">
                            <div class="template-thumbnail">
                                <i class="fas fa-network-wired"></i>
                            </div>
                            <div class="template-title">Basic Cloud Deployment</div>
                            <div class="template-description">Standard Portnox Cloud NAC deployment</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="template-card" data-template="eap_tls_authentication">
                            <div class="template-thumbnail">
                                <i class="fas fa-key"></i>
                            </div>
                            <div class="template-title">EAP-TLS Authentication</div>
                            <div class="template-description">Certificate-based authentication flow</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="template-card" data-template="dynamic_vlan_assignment">
                            <div class="template-thumbnail">
                                <i class="fas fa-project-diagram"></i>
                            </div>
                            <div class="template-title">Dynamic VLAN Assignment</div>
                            <div class="template-description">Role and device-based segmentation</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Load diagram libraries -->
    <script src="js/diagrams/mxClient.js"></script>
    <script src="js/diagrams/diagram-generator.js"></script>
    <script src="js/diagrams/diagram-ui.js"></script>
    <script>
        // Initialize diagram UI
        document.addEventListener('DOMContentLoaded', function() {
            // Initialize UI
            if (typeof PortnoxDiagramUI !== 'undefined') {
                PortnoxDiagramUI.initialize();
            }
            
            // Toggle options panel
            const toggleBtn = document.getElementById('toggle-options');
            const optionsPanel = document.getElementById('diagram-options');
            
            if (toggleBtn && optionsPanel) {
                toggleBtn.addEventListener('click', function() {
                    if (optionsPanel.style.display === 'none') {
                        optionsPanel.style.display = 'block';
                        toggleBtn.innerHTML = '<i class="fas fa-times"></i> Hide Options';
                    } else {
                        optionsPanel.style.display = 'none';
                        toggleBtn.innerHTML = '<i class="fas fa-cog"></i> Options';
                    }
                });
            }
        });
    </script>
</body>
</html>
EOL

# Print completion message
echo -e "${GREEN}===========================================================${NC}"
echo -e "${GREEN}  Portnox NAC Diagram Integration Complete!               ${NC}"
echo -e "${GREEN}===========================================================${NC}"
echo -e "\n${BLUE}The script has:${NC}"
echo -e "- Created all necessary directories and files"
echo -e "- Generated SVG icons for all vendors and device types"
echo -e "- Created diagram templates for different deployment scenarios"
echo -e "- Implemented industry-specific diagrams for healthcare, education, etc."
echo -e "- Added authentication flows and security workflows"
echo -e "- Created a self-contained diagramming engine"
echo -e "- Added a user-friendly UI for diagram generation"
echo -e "- Created a test page to verify functionality"

echo -e "\n${YELLOW}To finalize the integration, run:${NC}"
echo -e "${GREEN}./portnox_diagrams_integration.sh${NC}"

echo -e "\n${BLUE}This script will update your index.html file${NC}"
echo -e "${BLUE}to include the diagram components, and verify the installation.${NC}"

echo -e "\n${GREEN}Your Portnox NAC diagram integration is ready for use. You can open${NC}"
echo -e "${GREEN}test_portnox_diagrams.html to see the diagrams in action.${NC}"
