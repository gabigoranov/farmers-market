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

async function fetchData() {
    const response = await fetch(`/User/Statistics/`);
    const data = await response.json();
    console.log(data);
    return data;
}


async function loadProductPerformanceChart() {
    let data = await fetchData("orders");
    
    const productPerformance = {};
    data.forEach(order => {
        const productName = order.offer.title;
        if (productPerformance[productName]) {
            productPerformance[productName] += order.quantity;
        } else {
            productPerformance[productName] = order.quantity;
        }
    });

    const labels = Object.keys(productPerformance);
    const performanceData = Object.values(productPerformance);

    const ctxProductPerformance = document.getElementById('productPerformanceChart').getContext('2d');
    const dataProductPerformance = {
        labels: labels,
        datasets: [{
            label: 'Quantity Sold',
            data: performanceData,
            backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0'],
            borderColor: ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0'],
            borderWidth: 1
        }]
    };
    const optionsProductPerformance = {
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
    createBarChart(ctxProductPerformance, dataProductPerformance, optionsProductPerformance);
}

async function loadSalesTrendChart() {
    let data = await fetchData("orders");

    const salesTrend = {};
    data.forEach(order => {
        const date = new Date(order.dateOrdered).toLocaleDateString();
        if (salesTrend[date]) {
            salesTrend[date] += order.quantity;
        } else {
            salesTrend[date] = order.quantity;
        }
    });

    const labels = Object.keys(salesTrend);
    const trendData = Object.values(salesTrend);

    const ctxSalesTrend = document.getElementById('salesTrendChart').getContext('2d');
    const dataSalesTrend = {
        labels: labels,
        datasets: [{
            label: 'Sales Trend',
            data: trendData,
            backgroundColor: 'rgba(75, 192, 192, 0.2)',
            borderColor: 'rgba(75, 192, 192, 1)',
            borderWidth: 1
        }]
    };
    const optionsSalesTrend = {
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
    createLineChart(ctxSalesTrend, dataSalesTrend, optionsSalesTrend);
}

async function loadRevenueGrowthChart() {
    let data = await fetchData("orders");

    const revenueGrowth = {};
    data.forEach(order => {
        const date = new Date(order.dateOrdered).toLocaleDateString();
        if (revenueGrowth[date]) {
            revenueGrowth[date] += order.price * order.quantity;
        } else {
            revenueGrowth[date] = order.price * order.quantity;
        }
    });

    const labels = Object.keys(revenueGrowth);
    const growthData = Object.values(revenueGrowth);

    const ctxRevenueGrowth = document.getElementById('revenueGrowthChart').getContext('2d');
    const dataRevenueGrowth = {
        labels: labels,
        datasets: [{
            label: 'Revenue Growth',
            data: growthData,
            backgroundColor: 'rgba(153, 102, 255, 0.2)',
            borderColor: 'rgba(153, 102, 255, 1)',
            borderWidth: 1
        }]
    };
    const optionsRevenueGrowth = {
        responsive: true,
        plugins: {
            legend: {
                position: 'top',
            },
            tooltip: {
                callbacks: {
                    label: function (tooltipItem) {
                        return `${tooltipItem.label}: $${tooltipItem.raw.toFixed(2)}`;
                    }
                }
            }
        }
    };
    createLineChart(ctxRevenueGrowth, dataRevenueGrowth, optionsRevenueGrowth);
}
async function loadStatistics(sellerId) {
    try {
        const data = await fetchData("seller", sellerId);

        // Check if data.orders exists and is an array
        if (!data.orders || !Array.isArray(data.orders)) {
            throw new Error("Invalid data format: Orders is missing or not an array");
        }

        // Load pastIncomeChart
        const revenues = data.orders.map(order => order.price);
        const datesOrdered = data.orders.map(order => {
            const date = new Date(order.dateOrdered);
            return `${date.getDate()}/${date.getMonth() + 1}/${date.getFullYear()}`;
        });
        const totalRevenue = revenues.reduce((sum, revenue) => sum + revenue, 0);

        const ctxIncome = document.getElementById('pastIncomeChart').getContext('2d');
        createIncomeChart(ctxIncome, {
            labels: datesOrdered,
            values: revenues,
            totalIncome: totalRevenue
        });

        // Load orderBreakdownChart
        const ctxBreakdown = document.getElementById('orderBreakdownChart').getContext('2d');
        const dataBreakdown = {
            labels: Object.keys(data.categoryBreakdown || {}),
            datasets: [{
                label: 'Orders by Category',
                data: Object.values(data.categoryBreakdown || {}),
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

        // Load productPerformanceChart
        const ctxProductPerformance = document.getElementById('productPerformanceChart').getContext('2d');
        const dataProductPerformance = {
            labels: Object.keys(data.productPerformance || {}),
            datasets: [{
                label: 'Quantity Sold',
                data: Object.values(data.productPerformance || {}),
                backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0'],
                borderColor: ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0'],
                borderWidth: 1
            }]
        };
        createBarChart(ctxProductPerformance, dataProductPerformance, optionsBreakdown);

        // Load salesTrendChart
        const ctxSalesTrend = document.getElementById('salesTrendChart').getContext('2d');
        const dataSalesTrend = {
            labels: Object.keys(data.salesTrend || {}),
            datasets: [{
                label: 'Sales Trend',
                data: Object.values(data.salesTrend || {}),
                backgroundColor: 'rgba(75, 192, 192, 0.2)',
                borderColor: 'rgba(75, 192, 192, 1)',
                borderWidth: 1
            }]
        };
        createLineChart(ctxSalesTrend, dataSalesTrend, optionsBreakdown);

        // Load revenueGrowthChart
        const ctxRevenueGrowth = document.getElementById('revenueGrowthChart').getContext('2d');
        const dataRevenueGrowth = {
            labels: Object.keys(data.revenueGrowth || {}),
            datasets: [{
                label: 'Revenue Growth',
                data: Object.values(data.revenueGrowth || {}),
                backgroundColor: 'rgba(153, 102, 255, 0.2)',
                borderColor: 'rgba(153, 102, 255, 1)',
                borderWidth: 1
            }]
        };
        createLineChart(ctxRevenueGrowth, dataRevenueGrowth, optionsBreakdown);
    } catch (error) {
        console.error("Error loading statistics:", error);
    }
}