import * as Node from "/js/Node.mjs";
import Demo from "/js/Demo.mjs";

const nodeDatabase = [];

let cursorWireConnection = null;
let cursorWireDirectionOnNodeSide = null;

let draggingSelection = false;
let selectionWasDragged = false;
let dragInitiationTarget;

let panningSelection = false;
let awaitingGraphViewUpdate = false;

let graphOffsetX = 0;
let graphOffsetY = 0;
let graphScale = 1;
const scaleSpeed = 0.1;

export default async function NodeGraph() {
	setupEvents();

	const demoHappened = await Demo();
	if (!demoHappened) {
		const perlin = await addNode("Perlin Noise", 50, 50);
		const output = await addNode("Output", 400, 50);
		connectWire(perlin, "pattern", output, "diffuse");
	}
}

function setupEvents() {
	// const nodeGraph = document.querySelector(".node-graph");
	const nodeGraph = document.body;
	nodeGraph.addEventListener("mousedown", graphMousedownHandler);
	nodeGraph.addEventListener("mousemove", graphMousemoveHandler);
	nodeGraph.addEventListener("mouseup", graphMouseupHandler);
	nodeGraph.addEventListener("click", graphClickHandler);
	nodeGraph.addEventListener("wheel", graphWheelHandler);
	nodeGraph.addEventListener("keydown", graphKeydownHandler);
}

function graphMousedownHandler(event) {
	const target = event.target;
	dragInitiationTarget = target;

	// Left mouse button
	if (event.button === 0) {
		// No nodes selected (clear selection)
		if (!target.closest("section")) {
			deselectAllNodes();
			return;
		}

		// Connector dot selected
		if (target.closest("div.connector")) {
			const connector = target.closest("div.connector");
			const mousePosition = [event.clientX, event.clientY];
			const identifier = connector.dataset["identifier"];
			const nodeElement = connector.closest("section");
			const nodeData = nodeDatabase.find(node => node.element === nodeElement);
			const connectorInput = nodeData.inConnections[identifier];
			
			let targetPath;
			let targetNode = nodeData;
			let targetIdentifier = identifier;
			cursorWireDirectionOnNodeSide = connector.dataset["direction"];
			// Creating a new connection from output to mouse
			if (cursorWireDirectionOnNodeSide === "out") {
				targetPath = createWirePath(connector, mousePosition);
			}
			// Creating a new connection from mouse to input
			else if (cursorWireDirectionOnNodeSide === "in" && connectorInput.length == 0) {
				targetPath = createWirePath(mousePosition, connector);
			}
			// Moving an existing connection
			else if (cursorWireDirectionOnNodeSide === "in" && connectorInput.length > 0) {
				const sourceSide = connectorInput[0];
				disconnectWire(sourceSide.node, sourceSide.identifier, nodeData, identifier);
				
				const connectorElement = sourceSide.node.element.querySelector(`.connector[data-identifier="${sourceSide.identifier}"]`);
				cursorWireDirectionOnNodeSide = "out";
				targetNode = sourceSide.node;
				targetIdentifier = sourceSide.identifier;
				targetPath = createWirePath(connectorElement, mousePosition);
			}

			cursorWireConnection = { node: null, identifier: null, wire: null };
			cursorWireConnection.node = targetNode;
			cursorWireConnection.identifier = targetIdentifier;
			cursorWireConnection.wire = targetPath;

			return;
		}

		if (target.closest("select")) {
			return;
		}

		if (target.closest("input")) {
			// Prevent input selection until click handler
			if (target !== document.activeElement) event.preventDefault();
			event.stopPropagation();
			return;
		}

		// Node selected
		if (target.closest("section")) {
			const nodeElement = target.closest("section");
			const nodeData = nodeDatabase.find(node => node.element === nodeElement);

			if (nodeData.selected) {
				if (event.shiftKey || event.ctrlKey) {
					deselectNode(nodeData);

					// Prevent shift-selection from highlighting text
					event.preventDefault();
				}
				else {
					draggingSelection = true;
				}
			}
			else {
				// Add to current selection
				if (event.shiftKey || event.ctrlKey) {
					selectNode(nodeData, true);
					draggingSelection = true;

					// Prevent shift-selection from highlighting text
					event.preventDefault();
				}
				// Replace current selection
				else {
					deselectAllNodes();
					selectNode(nodeData, true);
					draggingSelection = true;
				}
			}

			return;
		}

		// Prevent dragging the background from highlighting text
		if (dragInitiationTarget === document.body) {
			event.preventDefault();
		}
	}

	// Middle mouse button
	if (event.button === 1) {
		if (!panningSelection) {
			panningSelection = true;
			return;
		}
	}
}

function graphMousemoveHandler(event) {
	const mousePosition = [event.clientX, event.clientY];
	const mouseDelta = [event.movementX / graphScale, event.movementY / graphScale];

	if (panningSelection && (event.movementX !== 0 || event.movementY !== 0)) {
		graphOffsetX += mouseDelta[0] * graphScale;
		graphOffsetY += mouseDelta[1] * graphScale;
		updateGraphView();
	}

	if (draggingSelection) {
		moveSelectedNodes(mouseDelta);
		
		// Prevent mouse drag from highlighting text
		event.preventDefault();
	}

	if (cursorWireConnection) {
		const attachedConnectorElement = cursorWireConnection.node.element.querySelector(`.connector[data-identifier="${cursorWireConnection.identifier}"]`);
		
		if (cursorWireDirectionOnNodeSide === "out") updateWirePath(cursorWireConnection.wire, attachedConnectorElement, mousePosition);
		else if (cursorWireDirectionOnNodeSide === "in") updateWirePath(cursorWireConnection.wire, mousePosition, attachedConnectorElement);

		// Prevent mouse drag from highlighting text
		event.preventDefault();
	}

	// Prevent dragging the background from highlighting text
	if (dragInitiationTarget === document.body) {
		event.preventDefault();
	}
}

function graphMouseupHandler(event) {
	const target = event.target;

	// Left mouse button
	if (event.button === 0) {
		dragInitiationTarget = undefined;

		// Replace current selection if the selected group was not moved when clicking on a selected node
		if (target.closest("section") && !target.closest("label")) {
			const nodeElement = target.closest("section");
			const nodeData = nodeDatabase.find(node => node.element === nodeElement);

			if (nodeData.selected && !event.shiftKey && !event.ctrlKey && !selectionWasDragged) {
				deselectAllNodesExcept([nodeData]);
				selectNode(nodeData, true);
			}
		}

		if (cursorWireConnection) {
			const nodeSideData = cursorWireConnection.node;
			const nodeSideIdentifier = cursorWireConnection.identifier;

			if (target.closest(".connector")) {
				const nodeElement = target.closest("section");
				const nodeData = nodeDatabase.find(node => node.element === nodeElement);
				const nodeIdentifier = target.closest(".connector").dataset["identifier"];
				
				if (cursorWireDirectionOnNodeSide === "out") connectWire(nodeSideData, nodeSideIdentifier, nodeData, nodeIdentifier);
				else if (cursorWireDirectionOnNodeSide === "in") connectWire(nodeData, nodeIdentifier, nodeSideData, nodeSideIdentifier);
			}

			const path = cursorWireConnection.wire;
			destroyWirePath(path);

			cursorWireConnection = null;
			cursorWireDirectionOnNodeSide = null;
		}

		draggingSelection = false;
		selectionWasDragged = false;
	}

	// Middle mouse button
	if (event.button === 1) {
		if (panningSelection) {
			panningSelection = false;
			return;
		}
	}
}

function graphClickHandler(event) {
	const target = event.target;

	if (target.closest("input")) {
		if (target !== document.activeElement) target.select();
		event.stopPropagation();

		return;
	}
}

function graphWheelHandler(event) {
	const minScale = 0.1;
	const maxScale = 2.0;

	let deltaScale = graphScale * scaleSpeed * (event.deltaY / -100);
	const newScale = graphScale + deltaScale;
	const newScaleClamped = Math.min(Math.max(newScale, minScale), maxScale);
	const clampedExcess = newScale - newScaleClamped;
	const deltaScaleClamped = deltaScale - clampedExcess;

	graphScale = newScaleClamped;
	graphOffsetX -= deltaScaleClamped * event.target.closest("body").clientWidth / 2;
	graphOffsetY -= deltaScaleClamped * event.target.closest("body").clientHeight / 2;

	updateGraphView();

	event.preventDefault();
}

function graphKeydownHandler(event) {
	if (event.key.toLowerCase() === "a" && event.ctrlKey) {
		if (event.shiftKey) deselectAllNodes();
		else selectAllNodes();
		
		event.preventDefault();
		return;
	}

	if (event.key.toLowerCase() === "p") {
		addNode("Perlin Noise");
	}

	if (event.key.toLowerCase() === "b") {
		addNode("Blend");
	}

	if (event.key.toLowerCase() === "c") {
		addNode("Color");
	}

	if (event.key.toLowerCase() === "enter" && document.activeElement.closest("input")) {
		document.activeElement.closest("input").blur();
	}

	if (event.key.toLowerCase() === "backspace" || event.key.toLowerCase() === "delete") {
		removeSelectedNodes();
	}
}

export function addNode(nodeName, x = 100, y = 100, startSelected = false) {
	return Node
	.createNode(nodeName, x, y, startSelected)
	.then((nodeData) => {
		document.querySelector(".node-graph").appendChild(nodeData.element);
		nodeDatabase.push(nodeData);
		updateNodePosition(nodeData);
		return nodeData;
	});
}

export function removeNode(nodeData) {
	// Disallow removing the single output node
	if (nodeData.name === "Output") return;

	// Keep a list of every in and out connection to remove at the end
	const inConnectionsToRemove = [];
	const outConnectionsToRemove = [];

	// Find all wires connected as inputs to remove
	Object.keys(nodeData.inConnections).forEach((connectorName) => {
		const connector = nodeData.inConnections[connectorName];
		connector.forEach((connection) => {
			const outNodeConnectors = connection.node.outConnections;
			Object.keys(outNodeConnectors).forEach((outConnectorName) => {
				const outConnector = outNodeConnectors[outConnectorName];
				outConnector.forEach((outConnection) => {
					if (outConnection.identifier === connectorName && outConnection.node === nodeData) {
						inConnectionsToRemove.push([connection.node, outConnectorName, nodeData, connectorName]);
					}
				});
			});
		});
	});
	
	// Find all wires connected as outputs to remove
	Object.keys(nodeData.outConnections).forEach((connectorName) => {
		const connector = nodeData.outConnections[connectorName];
		connector.forEach((connection) => {
			const inNodeConnectors = connection.node.inConnections;
			Object.keys(inNodeConnectors).forEach((inConnectorName) => {
				const inConnector = inNodeConnectors[inConnectorName];
				inConnector.forEach((inConnection) => {
					if (inConnection.identifier === connectorName && inConnection.node === nodeData) {
						outConnectionsToRemove.push([nodeData, connectorName, connection.node, inConnectorName]);
					}
				});
			});
		});
	});

	// Now remove those found connections once the looping is over
	inConnectionsToRemove.forEach((toRemove) => disconnectWire(...toRemove));
	outConnectionsToRemove.forEach((toRemove) => disconnectWire(...toRemove));

	// Deselect the node to remove the selection outline element
	deselectNode(nodeData);

	// Remove the node from the DOM
	nodeData.element.parentElement.removeChild(nodeData.element);

	// Remove the node from the node database
	nodeDatabase.splice(nodeDatabase.indexOf(nodeData), 1);
}

function removeSelectedNodes() {
	nodeDatabase.filter(node => node.selected).forEach(nodeData => removeNode(nodeData));
}

function moveSelectedNodes(deltaMove) {
	nodeDatabase.forEach((nodeData) => {
		if (nodeData.selected) {
			nodeData.x += deltaMove[0];
			nodeData.y += deltaMove[1];
			updateNodePosition(nodeData);
		}
	});

	if (deltaMove[0] !== 0 || deltaMove[1] !== 0) selectionWasDragged = true;
}

function selectAllNodes() {
	nodeDatabase.forEach((nodeData) => {
		selectNode(nodeData, false);
	});
}

function deselectAllNodes() {
	nodeDatabase.forEach((nodeData) => {
		deselectNode(nodeData);
	});
}

function deselectAllNodesExcept(nodesArray) {
	nodeDatabase.forEach((nodeData => {
		if (!nodesArray.includes(nodeData)) deselectNode(nodeData);
	}));
}

function selectNode(nodeData, bringToFront) {
	if (nodeData.selected) return;

	nodeData.element.classList.add("selected");
	if (bringToFront) nodeData.element.parentNode.insertAdjacentElement("beforeend", nodeData.element);
	nodeData.selected = Node.createNodeOutlineElement(nodeData);
	updateSelectionOutline(nodeData);
}

function deselectNode(nodeData) {
	if (!nodeData.selected) return;

	nodeData.element.classList.remove("selected");
	nodeData.selected.parentNode.removeChild(nodeData.selected);
	nodeData.selected = null;
}

function updateSelectionOutline(nodeData) {
	if (!nodeData.selected) return;

	const bounds = nodeData.element.getBoundingClientRect();
	const scale = bounds.width / nodeData.element.clientWidth;
	nodeData.selected.style.width = `${bounds.width}px`;
	nodeData.selected.style.height = `${bounds.height}px`;
	nodeData.selected.style.left = `${bounds.left}px`;
	nodeData.selected.style.top = `${bounds.top}px`;
	nodeData.selected.style.borderRadius = `${10 * scale}px`;
}

function updateGraphView() {
	if (!awaitingGraphViewUpdate) {
		requestAnimationFrame(() => {
			nodeDatabase.forEach((node) => {
				updateNodePosition(node);
			});
			awaitingGraphViewUpdate = false;
		});
	}
	awaitingGraphViewUpdate = true;
}

function updateNodePosition(nodeData) {
	nodeData.element.style.transform = `translate(${nodeData.x * graphScale + graphOffsetX}px, ${nodeData.y * graphScale + graphOffsetY}px) scale(${graphScale})`;
	updateSelectionOutline(nodeData);

	// Update any wires connected to out connections
	Object.keys(nodeData.outConnections).forEach((identifier) => {
		const connections = nodeData.outConnections[identifier];

		connections.forEach((connection) => {
			const path = connection.wire;

			const outConnectorElement = nodeData.element;
			const outConnector = outConnectorElement.querySelector(`.connector[data-identifier="${identifier}"]`);

			const inConnectorElement = connection.node.element;
			const inConnector = inConnectorElement.querySelector(`.connector[data-identifier="${connection.identifier}"]`);

			updateWirePath(path, outConnector, inConnector);
		});
	});

	// Update any wires connected to in connections
	Object.keys(nodeData.inConnections).forEach((identifier) => {
		const connections = nodeData.inConnections[identifier];

		connections.forEach((connection) => {
			const path = connection.wire;

			const inConnectorElement = nodeData.element;
			const inConnector = inConnectorElement.querySelector(`.connector[data-identifier="${identifier}"]`);

			const outConnectorElement = connection.node.element;
			const outConnector = outConnectorElement.querySelector(`.connector[data-identifier="${connection.identifier}"]`);

			updateWirePath(path, outConnector, inConnector);
		});
	});
}

function updateWirePath(path, outConnector, inConnector) {
	let outConnectorX;
	let outConnectorY;

	if (outConnector instanceof HTMLElement) {
		const outConnectorRect = outConnector.getBoundingClientRect();
		outConnectorX = outConnectorRect.left + outConnectorRect.width / 2;
		outConnectorY = outConnectorRect.top + outConnectorRect.height / 2;
	}
	else {
		outConnectorX = outConnector[0];
		outConnectorY = outConnector[1];
	}

	let inConnectorX;
	let inConnectorY;
	if (inConnector instanceof HTMLElement) {
		const inConnectorRect = inConnector.getBoundingClientRect();
		inConnectorX = inConnectorRect.left + inConnectorRect.width / 2;
		inConnectorY = inConnectorRect.top + inConnectorRect.height / 2;
	}
	else {
		inConnectorX = inConnector[0];
		inConnectorY = inConnector[1];
	}

	const horizontalGap = Math.abs(outConnectorX - inConnectorX);
	const curveLength = 200;
	const curveFalloffRate = curveLength * Math.PI * 2;
	const curveAmount = (-(2 ** (-10 * horizontalGap / curveFalloffRate)) + 1);
	const curve = curveAmount * curveLength;

	let pathString = `M${outConnectorX},${outConnectorY} C${outConnectorX + curve},${outConnectorY} ${inConnectorX - curve},${inConnectorY} ${inConnectorX},${inConnectorY}`;
	path.setAttribute("d", pathString);
}

function createWirePath(outConnector, inConnector) {
	const path = document.createElementNS("http://www.w3.org/2000/svg", "path");
	updateWirePath(path, outConnector, inConnector);
	document.querySelector("svg.wires").appendChild(path);
	return path;
}

function destroyWirePath(path) {
	path.parentElement.removeChild(path);
}

export function connectWire(outNodeData, outNodeIdentifier, inNodeData, inNodeIdentifier) {
	// Prevent connecting nodes as input->input or output->output
	if (!(outNodeIdentifier in outNodeData.outConnections && inNodeIdentifier in inNodeData.inConnections)) return;

	// Prevent connecting a node to itself
	if (outNodeData === inNodeData) return;

	// Prevent adding duplicate identical connections
	if (connectionAlreadyExists(outNodeData, outNodeIdentifier, inNodeData, inNodeIdentifier)) return;

	// Connect the wire to the output
	const outConnection = { node: inNodeData, identifier: inNodeIdentifier, wire: null };
	outNodeData.outConnections[outNodeIdentifier].push(outConnection);

	// Clear any existing inputs because inputs are exclusive to one wire
	inNodeData.inConnections[inNodeIdentifier].forEach((inConnectionSource) => {
		const outNodeDataForConnection = inConnectionSource.node;
		const outNodeIdentifierForConnection = inConnectionSource.identifier;
		disconnectWire(outNodeDataForConnection, outNodeIdentifierForConnection, inNodeData, inNodeIdentifier);
	});

	// Connect the wire to the input
	const inConnection = { node: outNodeData, identifier: outNodeIdentifier, wire: null };
	inNodeData.inConnections[inNodeIdentifier].push(inConnection);
	
	// Notify widgets on this node bound to the identifier so they can update
	Node.notifyBoundWidgetsOfUpdatedProperty(inNodeData, inNodeIdentifier);
	
	// Recompute everything downstream
	Node.recomputeDownstreamNodes(inNodeData);

	// Find the connector dot DOM elements and increment the connection degrees
	const outConnector = outNodeData.element.querySelector(`.connector[data-identifier="${outNodeIdentifier}"]`);
	const inConnector = inNodeData.element.querySelector(`.connector[data-identifier="${inNodeIdentifier}"]`);
	outConnector.dataset["outdegree"]++;
	inConnector.dataset["indegree"]++;

	// Create an SVG wire path and save its reference on both connection sides
	const wire = createWirePath(outConnector, inConnector);
	outConnection.wire = wire;
	inConnection.wire = wire;

	// TODO: Implement a cycle detector that doesn't require the connection be already made, which would allow this code to moved to the top, thus preventing this from disconnecting any existing wire
	// Prevent connecting nodes in a cycle
	// if (Node.findChildNodeDepths(inNodeData) === null) disconnectWire(outNodeData, outNodeIdentifier, inNodeData, inNodeIdentifier);
}

function disconnectWire(outNodeData, outNodeIdentifier, inNodeData, inNodeIdentifier) {
	const outConnections = outNodeData.outConnections[outNodeIdentifier];
	const inConnections = inNodeData.inConnections[inNodeIdentifier];

	// Find and destroy the SVG wire path
	const connection = outConnections.find(c => c.node === inNodeData && c.identifier === inNodeIdentifier);

	// Filter the out/in connections to not include the in/out identifiers
	outConnections.splice(outConnections.indexOf(connection), 1);
	inConnections.splice(inConnections.indexOf(connection), 1);

	// Find the connector dot DOM elements and decrement the connection degrees
	const outConnector = outNodeData.element.querySelector(`.connector[data-identifier="${outNodeIdentifier}"]`);
	const inConnector = inNodeData.element.querySelector(`.connector[data-identifier="${inNodeIdentifier}"]`);
	outConnector.dataset["outdegree"]--;
	inConnector.dataset["indegree"]--;
	
	destroyWirePath(connection.wire);
	
	// Notify widgets on this node bound to the identifier so they can update
	Node.notifyBoundWidgetsOfUpdatedProperty(inNodeData, inNodeIdentifier);

	// Recompute everything downstream
	Node.recomputeDownstreamNodes(inNodeData);
}

function connectionAlreadyExists(outNodeData, outNodeIdentifier, inNodeData, inNodeIdentifier) {
	const outConnector = outNodeData.outConnections[outNodeIdentifier];
	const outConnection = outConnector.find(c => c.identifier === inNodeIdentifier);
	
	const inConnector = inNodeData.inConnections[inNodeIdentifier];
	const inConnection = inConnector.find(c => c.identifier === outNodeIdentifier);

	if (!outConnection || !inConnection) return false;

	const inNodeDataConnectedToOutConnection = outConnection.node;
	const outNodeConnectedToInConnection = inConnection.node;

	return inNodeDataConnectedToOutConnection === inNodeData && outNodeConnectedToInConnection === outNodeData;
}
