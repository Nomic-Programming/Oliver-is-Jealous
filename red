(function () {
    'use strict';

    // Global variables to hold GUI and connected box references
    let gui;
    let connectedBox;

    // Helper function to get the state node
    function getStateNode() {
        return Object.values(document.querySelector("#app > div > div"))[1].children[0]._owner.stateNode;
    }

    // Function to create the GUI
    function createGUI(isDashboard) {
        // Create GUI
        gui = document.createElement("div");
        gui.style = "position:fixed; top:20px; left:20px; padding:15px; background:red; color:white; border-radius:8px; z-index:9999; display:block; width: 300px;";

        // Create top bar for dragging
        const topBar = document.createElement("div");
        topBar.innerText = "Epic Blooket Hack WOWZER";
        topBar.style = "cursor: move; background: #cc0000; padding: 10px; text-align: center; border-radius: 5px 5px 0 0; margin-bottom: 10px; user-select: none;";

        // Draggable functionality for the GUI
        let isDragging = false, offsetX, offsetY;
        topBar.onmousedown = (e) => {
            isDragging = true;
            offsetX = e.clientX - gui.offsetLeft;
            offsetY = e.clientY - gui.offsetTop;
            document.onmousemove = (e) => {
                if (isDragging) {
                    gui.style.left = e.clientX - offsetX + "px";
                    gui.style.top = e.clientY - offsetY + "px";
                }
            };
        };

        document.onmouseup = () => {
            isDragging = false;
            document.onmousemove = null;
        };

        gui.appendChild(topBar);

        // Button styling function
        function createButton(text, onClick) {
            const button = document.createElement("button");
            button.innerText = text;
            button.style.width = "100%";
            button.style.height = "40px";
            button.style.background = "#c32f2f";
            button.style.color = "white";
            button.style.border = "none";
            button.style.borderRadius = "5px";
            button.style.marginBottom = "10px";

            button.onclick = () => {
                button.style.background = "#9b2323";
                setTimeout(() => {
                    button.style.background = "#c32f2f";
                }, 300);
                onClick();
            };

            return button;
        }

        gui.appendChild(createButton(isDashboard ? "Use All Blooks (Be Careful)" : "Use Any Blook", useAnyBlook));

        if (!isDashboard) {
            const changeBlookButton = createButton("Change Blook Ingame", () => {
                const blook = input.value.trim();
                if (blook) {
                    changeBlookIngame(blook);
                } else {
                    alert("Please enter a blook name.");
                }
            });
            gui.appendChild(changeBlookButton);

            const input = document.createElement("input");
            input.type = "text";
            input.placeholder = "Enter Blook (case sensitive)";
            input.style.width = "100%";
            input.style.height = "40px";
            input.style.boxSizing = "border-box";
            input.style.padding = "8px";
            input.style.marginBottom = "10px";
            input.style.borderRadius = "5px";
            gui.appendChild(input);
        }

        const footer = document.createElement("div");
        footer.innerText = "Made by @chickenman2763 on Discord.";
        footer.style.marginTop = "10px";
        footer.style.fontSize = "12px";
        footer.style.userSelect = "none";
        gui.appendChild(footer);

        document.body.appendChild(gui);
    }

    // Function to create the connected box
    function createConnectedBox() {
        connectedBox = document.createElement("div");
        connectedBox.style = "position:fixed; top:20px; left:20px; padding:15px; background:red; color:white; border-radius:8px; z-index:9999; display:block; width: 300px;";

        const topBar = document.createElement("div");
        topBar.innerText = "Connected";
        topBar.style = "cursor: move; background: #cc0000; padding: 10px; text-align: center; border-radius: 5px 5px 0 0; margin-bottom: 10px; user-select: none;";

        let isDragging = false, offsetX, offsetY;
        topBar.onmousedown = (e) => {
            isDragging = true;
            offsetX = e.clientX - connectedBox.offsetLeft;
            offsetY = e.clientY - connectedBox.offsetTop;
            document.onmousemove = (e) => {
                if (isDragging) {
                    connectedBox.style.left = e.clientX - offsetX + "px";
                    connectedBox.style.top = e.clientY - offsetY + "px";
                }
            };
        };

        document.onmouseup = () => {
            isDragging = false;
            document.onmousemove = null;
        };

        connectedBox.appendChild(topBar);

        const connectedText = document.createElement("div");
        connectedText.innerHTML = `<div style="text-align: center;">
            Connected to Blooket<br>
            Waiting for Join
        </div>`;
        connectedBox.appendChild(connectedText);

        const footer = document.createElement("div");
        footer.innerText = "Made by @chickenman2763 on Discord.";
        footer.style.marginTop = "10px";
        footer.style.fontSize = "12px";
        footer.style.userSelect = "none";
        connectedBox.appendChild(footer);

        document.body.appendChild(connectedBox);
    }

    const isDashboard = window.location.hostname === "dashboard.blooket.com";
    const isPlay = window.location.hostname === "play.blooket.com";

    if (isPlay) {
        createConnectedBox();
    } else {
        createGUI(isDashboard);
    }

    function useAnyBlook() {
        const stateNode = getStateNode();
        const lobby = window.location.pathname.startsWith("/play/lobby");
        const blooks = !lobby && window.location.pathname.startsWith("/blooks");

        if (!blooks && !lobby) {
            alert("This only works in lobbies or the dashboard blooks page.");
            return;
        }

        let data = null;
        function getBlooks(isLobby) {
            if (data?.Black) return;
            const oldMethod = Object[isLobby ? "keys" : "entries"];
            Object[isLobby ? "keys" : "entries"] = function (obj) {
                if (!obj.Chick) return oldMethod.call(this, obj);
                data = obj;
                return (Object[isLobby ? "keys" : "entries"] = oldMethod).call(this, obj);
            };
            stateNode.render();
        }

        getBlooks(lobby);
        if (lobby) {
            stateNode.setState({ unlocks: Object.keys(data) });
        } else {
            stateNode.setState({
                blookData: Object.keys(data).reduce((acc, blook) => ((acc[blook] = stateNode.state.blookData[blook] || 1), acc), {}),
                allSets: Object.values(data).reduce((acc, blook) => (blook.set && !acc.includes(blook.set) ? acc.concat(blook.set) : acc), [])
            });
        }
    }

    function changeBlookIngame(blook) {
        const stateNode = getStateNode();
        const { props } = stateNode;

        if (!props || !props.liveGameController) {
            alert("You must be in a game to change the blook.");
            return;
        }

        try {
            props.liveGameController.setVal({ path: `c/${props.client.name}/b`, val: (props.client.blook = blook) });
            alert(`Blook changed to: ${blook}`);
        } catch (error) {
            console.error("Error changing blook:", error);
            alert("Failed to change blook. Check the console for details.");
        }
    }

    // Toggle visibility with Command+E (Mac) or Control+E
    document.addEventListener("keydown", (e) => {
        if ((e.ctrlKey || e.metaKey) && e.key === "e") {
            if (gui) {
                gui.style.display = gui.style.display === "none" ? "block" : "none";
            }
            if (connectedBox) {
                connectedBox.style.display = connectedBox.style.display === "none" ? "block" : "none";
            }
        }
    });
})();
