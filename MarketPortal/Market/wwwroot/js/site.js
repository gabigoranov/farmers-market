function toggleSidebar() {
    var x = document.getElementsByClassName("sidebar-container")[0];
    var icon = document.getElementById("hamburger-icon");
    if (x.style.display === "flex") {
        x.style.display = "none";
        x.classList.toggle("open");
        x.offsetHeight;
        icon.children[0].className = "fa fa-bars";

    } else {
        x.style.display = "flex";
        x.classList.toggle("open");
        x.offsetHeight;
        icon.children[0].className = "fa-solid fa-xmark";
    }
}
function createIncomeChart(ctx, data) {
    return new Chart(ctx, {
        type: 'line',
        data: {
            labels: data.labels,
            datasets: [{
                label: `Orders, Income: ${data.totalIncome}`,
                data: data.values,
                backgroundColor: 'rgba(75, 192, 192, 0.2)',
                borderColor: 'rgba(75, 192, 192, 1)',
                borderWidth: 1
            }]
        },
        options: {
            scales: {
                x: { display: true },
                y: { display: true }
            }
        }
    });
}

function createBarChart(ctx, data, config) {
    return new Chart(ctx, {
        type: 'bar',
        data: data,
        options: config
    });
}

function createDoughnutChart(ctx, data, config) {
    return new Chart(ctx, {
        type: 'doughnut',
        data: data,
        options: config
    });
}

function createLineChart(ctx, data, config) {
    return new Chart(ctx, {
        type: 'line',
        data: data,
        options: config
    });
}

async function fetchData(endpoint) {
    const response = await fetch(`/Orders/Stats?endpoint=${endpoint}`);
    const data = await response.json();
    //console.log(data);
    return data;
}

async function loadStatistics() {
    //Load pastIncomeChart
    let data = await fetchData("orders");

    const approvedOrders = data.filter(item => item.isAccepted);
    const revenues = approvedOrders.map(item => item.price);
    const datesOrdered = approvedOrders.map(item => {
        const date = new Date(item.dateOrdered);
        const day = String(date.getDate()).padStart(2, '0');
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const year = String(date.getFullYear()).slice(-2);
        return `${day}/${month}/${year}`;
    });
    const totalRevenue = revenues.reduce((sum, revenue) => sum + revenue, 0);

    const ctxIncome = document.getElementById('pastIncomeChart').getContext('2d');
    createIncomeChart(ctxIncome, {
        labels: datesOrdered,
        values: revenues,
        totalIncome: totalRevenue
    });

    //Load orderBreakdownChart

    const categories = {};
    data.forEach(order => {
        const category = order.offer.stock.offerType.category;
        if (categories[category]) {
            categories[category] += order.quantity;
        } else {
            categories[category] = order.quantity;
        }
    });

    // Prepare data for Chart.js
    const labels = Object.keys(categories);
    const breakdownData = Object.values(categories);

    // Create the chart
    const ctxBreakdown = document.getElementById('orderBreakdownChart').getContext('2d');
    const dataBreakdown = {
        labels: labels,
        datasets: [{
            label: 'Orders by Category',
            data: breakdownData,
            backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0'],
            hoverOffset: 4
        }]
    };
    const optionsBreakdown = {
        responsive: true,
        plugins: {
            legend: {
                position: 'top',
            },
            tooltip: {
                callbacks: {
                    label: function (tooltipItem) {
                        return `${tooltipItem.label}: ${tooltipItem.raw} kg`;
                    }
                }
            }
        }
    };
    createDoughnutChart(ctxBreakdown, dataBreakdown, optionsBreakdown);
}


