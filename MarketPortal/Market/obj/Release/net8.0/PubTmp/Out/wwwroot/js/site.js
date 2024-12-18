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

function loadStatistics(data, apiUrl) {
    // Income Chart
    const ctxIncome = document.getElementById('pastIncomeChart').getContext('2d');
    createIncomeChart(ctxIncome, {
        labels: data.income.labels,
        values: data.income.values,
        totalIncome: data.income.total
    });

    // Product Performance Chart
    fetch(apiUrl)
        .then(response => response.json())
        .then(apiData => {
            const productData = {
                labels: apiData.map(offer => offer.title),
                datasets: [{
                    label: 'Units Sold',
                    data: apiData.map(offer => offer.units_sold),
                    backgroundColor: [
                        'rgba(255, 99, 132, 0.7)',
                        'rgba(54, 162, 235, 0.7)',
                        'rgba(255, 206, 86, 0.7)',
                        'rgba(75, 192, 192, 0.7)',
                        'rgba(153, 102, 255, 0.7)',
                        'rgba(255, 159, 64, 0.7)'
                    ],
                    borderColor: [
                        'rgba(255, 99, 132, 1)',
                        'rgba(54, 162, 235, 1)',
                        'rgba(255, 206, 86, 1)',
                        'rgba(75, 192, 192, 1)',
                        'rgba(153, 102, 255, 1)',
                        'rgba(255, 159, 64, 1)'
                    ],
                    borderWidth: 1
                }]
            };
            const configProduct = {
                responsive: true,
                plugins: {
                    legend: { position: 'top' },
                    title: { display: true, text: 'Product Performance - Units Sold' }
                },
                scales: {
                    y: { beginAtZero: true, title: { display: true, text: 'Units Sold' } },
                    x: { title: { display: true, text: 'Products' } }
                }
            };
            const ctxProduct = document.getElementById('productPerformanceChart').getContext('2d');
            createBarChart(ctxProduct, productData, configProduct);
        })
        .catch(error => console.error('Error fetching product data:', error));

    // Order Breakdown Chart
    const orderData = {
        labels: ["Vegetables", "Dairy", "Meat", "Fruits", "Bakery", "Beverages"],
        datasets: [{
            label: 'Order Breakdown',
            data: [30, 25, 15, 20, 10, 18],
            backgroundColor: [
                'rgba(255, 99, 132, 0.7)',
                'rgba(54, 162, 235, 0.7)',
                'rgba(255, 206, 86, 0.7)',
                'rgba(75, 192, 192, 0.7)',
                'rgba(153, 102, 255, 0.7)',
                'rgba(255, 159, 64, 0.7)'
            ],
            borderColor: [
                'rgba(255, 99, 132, 1)',
                'rgba(54, 162, 235, 1)',
                'rgba(255, 206, 86, 1)',
                'rgba(75, 192, 192, 1)',
                'rgba(153, 102, 255, 1)',
                'rgba(255, 159, 64, 1)'
            ],
            borderWidth: 1
        }]
    };
    const configOrder = {
        responsive: true,
        plugins: {
            legend: { position: 'right' },
            title: { display: true, text: 'Order Breakdown by Category' }
        }
    };
    const ctxOrder = document.getElementById('orderBreakdownChart').getContext('2d');
    createDoughnutChart(ctxOrder, orderData, configOrder);

    // Top Sellers Chart
    const topSellersData = {
        labels: ["Farmer A", "Farmer B", "Farmer C", "Farmer D", "Farmer E"],
        datasets: [{
            label: 'Total Revenue (in USD)',
            data: [5000, 4200, 3900, 3700, 3500],
            backgroundColor: [
                'rgba(255, 99, 132, 0.7)',
                'rgba(54, 162, 235, 0.7)',
                'rgba(255, 206, 86, 0.7)',
                'rgba(75, 192, 192, 0.7)',
                'rgba(153, 102, 255, 0.7)'
            ],
            borderColor: [
                'rgba(255, 99, 132, 1)',
                'rgba(54, 162, 235, 1)',
                'rgba(255, 206, 86, 1)',
                'rgba(75, 192, 192, 1)',
                'rgba(153, 102, 255, 1)'
            ],
            borderWidth: 1
        }]
    };
    const configTopSellers = {
        responsive: true,
        plugins: {
            legend: {
                position: 'top',
            },
            title: {
                display: true,
                text: 'Top Sellers by Revenue'
            }
        },
        scales: {
            x: {
                title: {
                    display: true,
                    text: 'Sellers'
                }
            },
            y: {
                beginAtZero: true,
                title: {
                    display: true,
                    text: 'Revenue (in USD)'
                }
            }
        }
    };
    const ctxTopSellers = document.getElementById('topSellersChart').getContext('2d');
    createBarChart(ctxTopSellers, topSellersData, configTopSellers);

    // Revenue Growth Chart
    const revenueGrowthData = {
        labels: ["January", "February", "March", "April", "May", "June"],
        datasets: [{
            label: 'Revenue (in USD)',
            data: [2000, 2400, 2800, 3000, 3200, 3500],
            backgroundColor: 'rgba(75, 192, 192, 0.7)',
            borderColor: 'rgba(75, 192, 192, 1)',
            borderWidth: 2,
            fill: true,
            tension: 0.4
        }]
    };
    const configRevenueGrowth = {
        responsive: true,
        plugins: {
            legend: {
                position: 'top',
            },
            title: {
                display: true,
                text: 'Revenue Growth Over Time'
            }
        },
        scales: {
            x: {
                title: {
                    display: true,
                    text: 'Months'
                }
            },
            y: {
                beginAtZero: true,
                title: {
                    display: true,
                    text: 'Revenue (in USD)'
                }
            }
        }
    };
    const ctxRevenueGrowth = document.getElementById('revenueGrowthChart').getContext('2d');
    createLineChart(ctxRevenueGrowth, revenueGrowthData, configRevenueGrowth);
}
