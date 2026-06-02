document.addEventListener('DOMContentLoaded', function () {
  const codeBlocks = document.querySelectorAll('pre code');

  codeBlocks.forEach(function (codeBlock) {
    // Only number real code blocks. Plain ``` fences (tables, ASCII trees,
    // wireframes, cards) render as language-plaintext and stay clean.
    if (!isRealCodeBlock(codeBlock)) {
      return;
    }

    const lineNumbersContainer = document.createElement('div');
    lineNumbersContainer.className = 'line-numbers';

    const lines = codeBlock.innerHTML.split('\n');
    const lineCount = lines.length - 1;

    for (let i = 1; i <= lineCount; i++) {
      const lineNumber = document.createElement('span');
      lineNumber.className = 'line-number';
      lineNumber.textContent = i;
      lineNumbersContainer.appendChild(lineNumber);
    }

    codeBlock.parentNode.insertBefore(lineNumbersContainer, codeBlock);
  });
});

function isRealCodeBlock(codeBlock) {
  // Jekyll/Rouge puts the language class on the .highlighter-rouge wrapper.
  const wrapper = codeBlock.closest('.highlighter-rouge');
  const cls = (wrapper && wrapper.className) || codeBlock.className || '';
  const match = cls.match(/language-([\w-]+)/);
  if (!match) {
    return false;
  }
  const lang = match[1];
  return lang !== 'plaintext' && lang !== 'text';
}