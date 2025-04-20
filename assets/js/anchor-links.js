document.addEventListener('DOMContentLoaded', function () {
  // Get all headings
  const headings = document.querySelectorAll('h1, h2, h3, h4, h5, h6');

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