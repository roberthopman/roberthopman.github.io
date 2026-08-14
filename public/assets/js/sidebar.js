document.addEventListener('DOMContentLoaded', function () {
  const sidebar = document.querySelector('.sidebar');
  const sidebarToggle = document.querySelector('.sidebar-toggle');
  const sidebarLinks = document.querySelectorAll('.sidebar-link');
  const sections = document.querySelectorAll('h1[id], h2[id], h3[id], h4[id], h5[id], h6[id]');

  if (!sidebar) return;

  // Mobile sidebar functionality (simplified for inline layout)
  function initializeMobileToggle() {
    const sidebarNav = document.querySelector('.sidebar-nav');
    const toggleIcon = sidebarToggle ? sidebarToggle.querySelector('.toggle-icon') : null;

    // Set initial state on mobile
    if (window.innerWidth <= 768 && sidebarNav && toggleIcon) {
      sidebarNav.style.display = 'none';
      toggleIcon.textContent = '+';
    }

    if (sidebarToggle) {
      sidebarToggle.addEventListener('click', function () {
        if (sidebarNav) {
          const isHidden = sidebarNav.style.display === 'none' ||
            (window.innerWidth <= 768 && getComputedStyle(sidebarNav).display === 'none');

          sidebarNav.style.display = isHidden ? 'block' : 'none';
          if (toggleIcon) {
            toggleIcon.textContent = isHidden ? '−' : '+';
          }
        }
      });
    }

    // Reset on resize
    window.addEventListener('resize', function () {
      if (window.innerWidth > 768 && sidebarNav) {
        sidebarNav.style.display = '';
        if (toggleIcon) {
          toggleIcon.textContent = '−';
        }
      } else if (window.innerWidth <= 768 && sidebarNav && toggleIcon) {
        sidebarNav.style.display = 'none';
        toggleIcon.textContent = '+';
      }
    });
  }

  // Scroll highlighting
  function highlightCurrentSection() {
    let current = '';
    const scrollPosition = window.scrollY + 100; // Offset for better UX

    // Find the current section based on scroll position
    sections.forEach(function (section) {
      const sectionTop = section.offsetTop;

      if (scrollPosition >= sectionTop) {
        current = section.getAttribute('id');
      }
    });

    // Update active states
    sidebarLinks.forEach(function (link) {
      link.classList.remove('active');
      const href = link.getAttribute('href');
      if (href && current && href === '#' + current) {
        link.classList.add('active');
      }
    });
  }

  // Manual highlighting when clicking a link
  function setActiveLink(targetId) {
    sidebarLinks.forEach(function (link) {
      link.classList.remove('active');
      const href = link.getAttribute('href');
      if (href === '#' + targetId) {
        link.classList.add('active');
      }
    });
  }

  // Initialize
  initializeMobileToggle();
  highlightCurrentSection();

  // Listen for scroll events
  let scrollTimeout;
  window.addEventListener('scroll', function () {
    if (scrollTimeout) {
      clearTimeout(scrollTimeout);
    }
    scrollTimeout = setTimeout(highlightCurrentSection, 10);
  });
});