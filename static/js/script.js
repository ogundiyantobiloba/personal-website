document.addEventListener('DOMContentLoaded', function() {
    function adjustHeaderLogo() {
        let mediaQuery = window.matchMedia("(max-width: 37.5em)");
        let headerLogo = document.getElementById('header-logo');

        if (mediaQuery.matches) {
            headerLogo.textContent = 'T.O'; // Change to 'T.O' on smaller screens
        } else {
            headerLogo.textContent = 'Tobiloba Ogundiyan'; // Revert back on larger screens
        }
    }

    // Run on a load
    adjustHeaderLogo();

    // Add listener for window resize
    window.addEventListener('resize', adjustHeaderLogo);
});




