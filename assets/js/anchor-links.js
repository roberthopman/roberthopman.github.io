document.addEventListener('DOMContentLoaded', function () {
  // Get headings only from main content, not sidebar
  const mainContent = document.querySelector('.main-content') || document.querySelector('.post-content') || document.querySelector('main');
  const headings = mainContent ? mainContent.querySelectorAll('h1, h2, h3, h4, h5, h6') : document.querySelectorAll('.post-content h1, .post-content h2, .post-content h3, .post-content h4, .post-content h5, .post-content h6');

  headings.forEach(heading => {
    // Generate ID if it doesn't exist
    if (!heading.id) {
      heading.id = heading.textContent
        .toLowerCase()
        .replace(/[^a-z0-9]+/g, '-')
        .replace(/(^-|-$)/g, '');
    }

    // Create anchor link
    const anchorLink = document.createElement('a');
    anchorLink.href = `#${heading.id}`;
    anchorLink.className = 'anchor-link';
    anchorLink.innerHTML = 'link';
    anchorLink.title = `Link to ${heading.textContent.trim()}`;

    // Add anchor link to heading
    heading.appendChild(anchorLink);
  });
}); 