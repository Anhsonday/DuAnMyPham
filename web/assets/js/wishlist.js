// Utility Functions
function showLoading() {
    const loading = document.querySelector('.loading');
    if (loading) {
        loading.style.display = 'block';
    }
}

function hideLoading() {
    const loading = document.querySelector('.loading');
    if (loading) {
        loading.style.display = 'none';
    }
}

function showAlert(message, type = 'success') {
    const alertContainer = document.getElementById('alert-container');
    if (!alertContainer) return;

    const alert = document.createElement('div');
    alert.className = `alert alert-${type} alert-dismissible fade show`;
    alert.innerHTML = `
        ${message}
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
            <span aria-hidden="true">&times;</span>
        </button>
    `;
    alertContainer.appendChild(alert);

    // Tự động ẩn sau 3 giây
    setTimeout(() => {
        alert.remove();
    }, 3000);
}

// Wishlist Functions
function removeFromWishlist(wishlistId, productId) {
    if (!confirm('Bạn có chắc muốn xóa sản phẩm này khỏi danh sách yêu thích?')) {
        return;
    }
    
    showLoading();
    
    const contextPath = document.querySelector('meta[name="context-path"]').getAttribute('content');
    
    fetch(`${contextPath}/wishlist?action=remove`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: `wishlistId=${wishlistId}&productId=${productId}`
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json();
    })
    .then(data => {
        console.log('Server response:', data);
        if (data.success) {
            // Xóa item khỏi DOM
            const item = document.querySelector(`.wishlist-item[data-wishlist-id="${wishlistId}"]`);
            if (item) {
                item.remove();
            }
            
            // Cập nhật số lượng
            const countElement = document.getElementById('wishlist-count');
            if (countElement) {
                countElement.textContent = data.count;
            }
            
            // Cập nhật badge
            const badge = document.querySelector('.wishlist-count-badge');
            if (badge) {
                badge.textContent = data.count;
                badge.style.display = data.count > 0 ? 'inline-block' : 'none';
            }
            
            showAlert('Đã xóa sản phẩm khỏi danh sách yêu thích', 'success');
            
            // Nếu không còn sản phẩm nào
            if (data.count === 0) {
                location.reload();
            }
        } else {
            showAlert(data.message || 'Không thể xóa sản phẩm', 'danger');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showAlert('Có lỗi xảy ra khi xóa sản phẩm', 'danger');
    })
    .finally(() => {
        hideLoading();
    });
}

function clearAllWishlist() {
    if (!confirm('Bạn có chắc muốn xóa tất cả sản phẩm khỏi danh sách yêu thích?')) {
        return;
    }
    
    showLoading();
    
    const contextPath = document.querySelector('meta[name="context-path"]').getAttribute('content');
    
    fetch(`${contextPath}/wishlist?action=clear`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            location.reload();
        } else {
            showAlert(data.message || 'Có lỗi xảy ra khi xóa tất cả', 'danger');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showAlert('Có lỗi xảy ra khi xóa tất cả', 'danger');
    })
    .finally(() => {
        hideLoading();
    });
}
