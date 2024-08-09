window.addEventListener('message', function(event) {
    if (event.data.action === "openFuelHUD") {
        document.getElementById('fuelHUD').style.display = "block";
        document.getElementById('fuelPrice').textContent = `$${event.data.fuelPrice.toFixed(2)}`;
    } else if (event.data.action === "closeFuelHUD") {
        document.getElementById('fuelHUD').style.display = "none";
    }
});

document.getElementById('confirmFuel').addEventListener('click', function() {
    const method = selectedMethod;

    if (!method) {
        alert("Bitte wählen Sie eine Zahlungsmethode.");
        return;
    }

    fetch(`https://${GetParentResourceName()}/fuelConfirm`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8'
        },
        body: JSON.stringify({
            method: method
        })
    }).then(() => {
        document.getElementById('fuelHUD').style.display = "none";
    });
});

document.getElementById('cancelFuel').addEventListener('click', function() {
    fetch(`https://${GetParentResourceName()}/cancelFuel`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8'
        }
    }).then(() => {
        document.getElementById('fuelHUD').style.display = "none";
    });
});

let selectedMethod = null;

document.getElementById('payCash').addEventListener('click', function() {
    selectedMethod = 'cash';
});

document.getElementById('payCard').addEventListener('click', function() {
    selectedMethod = 'card';
});
