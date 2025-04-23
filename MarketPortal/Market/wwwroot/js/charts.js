document.addEventListener('DOMContentLoaded', async function () {
    // Fetch data from your API
    const orders = await fetchData();

    // Update summary cards
    updateSummaryCards(orders);

    // Create charts
    createProductSalesChart(orders);
    createOrderStatusChart(orders);
    createMonthlyRevenueChart(orders);
    createDeliveryTimeChart(orders);
});

async function fetchData() {
    try {
        const response = await fetch('/User/Statistics/');
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return await response.json();
    } catch (error) {
        console.error('Error fetching data:', error);
        return [];
    }
}

function updateSummaryCards(orders) {
    const totalOrders = orders.length;
    const completedOrders = orders.filter(o => o.status === 'Delivered').length;
    const pendingOrders = orders.filter(o => o.status === 'Accepted').length;
    const totalRevenue = orders
        .filter(o => o.status === 'Delivered')
        .reduce((sum, order) => sum + (order.price), 0);

    document.getElementById('totalOrders').textContent = totalOrders;
    document.getElementById('completedOrders').textContent = completedOrders;
    document.getElementById('pendingOrders').textContent = pendingOrders;
    document.getElementById('totalRevenue').textContent = `$${totalRevenue.toFixed(2)}`;
}

function createProductSalesChart(orders) {
    const productData = orders.reduce((acc, order) => {
        if (order.status === 'Delivered') {
            acc[order.title] = (acc[order.title] || 0) + order.quantity;
        }
        return acc;
    }, {});

    const ctx = document.getElementById('productSalesChart').getContext('2d');
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: Object.keys(productData),
            datasets: [{
                label: 'Quantity Sold',
                data: Object.values(productData),
                backgroundColor: 'rgba(52, 152, 219, 0.7)',
                borderColor: 'rgba(52, 152, 219, 1)',
                borderWidth: 1
            }]
        },
        options: getChartOptions('Sales by Product', 'Quantity Sold')
    });
}

function createOrderStatusChart(orders) {
    const statusData = orders.reduce((acc, order) => {
        acc[order.status] = (acc[order.status] || 0) + 1;
        return acc;
    }, {});

    const ctx = document.getElementById('orderStatusChart').getContext('2d');
    new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: Object.keys(statusData),
            datasets: [{
                data: Object.values(statusData),
                backgroundColor: [
                    'rgba(46, 204, 113, 0.7)',
                    'rgba(243, 156, 18, 0.7)',
                    'rgba(231, 76, 60, 0.7)',
                    'rgba(155, 89, 182, 0.7)'
                ],
                borderColor: '#fff',
                borderWidth: 1
            }]
        },
        options: getChartOptions('Order Status Distribution')
    });
}

function createMonthlyRevenueChart(orders) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    const revenueData = months.map(month => 0);

    orders.forEach(order => {
        if (order.status === 'Delivered' && order.dateOrdered) {
            const month = new Date(order.dateOrdered).getMonth();
            revenueData[month] += order.quantity * order.price;
        }
    });

    const ctx = document.getElementById('monthlyRevenueChart').getContext('2d');
    new Chart(ctx, {
        type: 'line',
        data: {
            labels: months,
            datasets: [{
                label: 'Revenue ($)',
                data: revenueData,
                fill: false,
                borderColor: 'rgba(155, 89, 182, 1)',
                backgroundColor: 'rgba(155, 89, 182, 0.2)',
                tension: 0.1
            }]
        },
        options: getChartOptions('Monthly Revenue', 'Revenue ($)')
    });
}

function createDeliveryTimeChart(orders) {
    const deliveryTimes = orders
        .filter(order => order.status === 'Delivered' && order.dateDelivered)
        .map(order => {
            const diff = new Date(order.dateDelivered) - new Date(order.dateOrdered);
            return Math.ceil(diff / (1000 * 60 * 60 * 24));
        });

    const avgTime = deliveryTimes.reduce((a, b) => a + b, 0) / deliveryTimes.length || 0;

    const ctx = document.getElementById('deliveryTimeChart').getContext('2d');
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['Average Delivery Time'],
            datasets: [{
                label: 'Days',
                data: [avgTime],
                backgroundColor: 'rgba(52, 152, 219, 0.7)',
                borderColor: 'rgba(52, 152, 219, 1)',
                borderWidth: 1
            }]
        },
        options: getChartOptions('Average Delivery Time', 'Days')
    });
}
function getChartOptions(title, yAxisTitle = '') {
    return {
        responsive: true,
        plugins: {
            title: {
                display: true,
                text: title,
                font: { size: 16 }
            },
            legend: {
                position: 'bottom'
            }
        },
        scales: {
            y: {
                beginAtZero: true,
                title: {
                    display: !!yAxisTitle,
                    text: yAxisTitle,
                    font: { weight: 'bold' }
                }
            }
        }
    };
}