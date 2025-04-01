export const isTokenExpired = () => {
    const expiresAt = localStorage.getItem('expiresAt');
    if (!expiresAt) return true

    return new Date() >= new Date(expiresAt)
}

export const refreshToken = async () => {
    try {
        const refreshToken = localStorage.getItem('refreshToken');

        if (!refreshToken) {
            throw new Error('No refresh token available');
        }

        const response = await fetch('https://api.cashcrate.shop/api/refresh', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ refreshToken }),
        });

        if (!response.ok) {
            throw new Error('Token refresh failed');
        }

        const data = await response.json();

        // Update stored tokens
        localStorage.setItem('accessToken', data.accessToken);
        localStorage.setItem('refreshToken', data.refreshToken);

        // Update expiration time (15 minutes from now)
        const expiresAt = new Date(new Date().getTime() + 15 * 60000).toISOString();
        localStorage.setItem('expiresAt', expiresAt);

        return data.accessToken;
    } catch (error) {
        console.error('Error refreshing token:', error);
        // Force logout on refresh failure
        localStorage.removeItem('accessToken');
        localStorage.removeItem('refreshToken');
        localStorage.removeItem('expiresAt');
        localStorage.removeItem('userId');
        window.location.href = '/login';
        throw error;
    }
}

export const getAccessToken = async () => {
    if (isTokenExpired()) {
        return await refreshToken();
    }
    return localStorage.getItem('accessToken');
};

// Utility function for making authenticated API requests
export const fetchWithAuth = async (url, options = {}) => {
    // Get a valid access token
    const token = await getAccessToken();

    // Create headers with authorization
    const headers = {
        ...options.headers,
        'Authorization': `Bearer ${token}`
    };

    // Make the request with the token
    return fetch(url, {
        ...options,
        headers
    });
};

export const logout = async (silent = false) => {
    try {
        if (!silent) {
            const accessToken = localStorage.getItem('accessToken');
            const refreshToken = localStorage.getItem('refreshToken');

            if (accessToken && refreshToken) {
                await fetch('https://api.cashcrate.shop/api/logout', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': `Bearer ${accessToken}`
                    },
                    body: JSON.stringify({ refreshToken: refreshToken})
                })
            }
        }
    } catch (error) {
        console.error('Error logging out:', error);
    } finally {
        localStorage.removeItem('accessToken');
        localStorage.removeItem('refreshToken');
        localStorage.removeItem('expiresAt');
        localStorage.removeItem('userId');

        window.location.href = '/login'
    }
}
