document.addEventListener('DOMContentLoaded', function () {
  const codeBlocks = document.querySelectorAll('pre code');

  codeBlocks.forEach(function (codeBlock) {
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