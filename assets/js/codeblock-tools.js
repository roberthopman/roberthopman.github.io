document.addEventListener('DOMContentLoaded', function () {
  const codeBlocks = document.querySelectorAll('pre code');

  codeBlocks.forEach(function (codeBlock) {
    const preElement = codeBlock.parentNode;

    const header = document.createElement('div');
    header.className = 'codeblock-header';

    const copyButton = createCopyButton(codeBlock);
    header.appendChild(copyButton);

    const tryRubyButton = createTryRubyButton(codeBlock);
    header.appendChild(tryRubyButton);

    const contentWrapper = document.createElement('div');
    contentWrapper.className = 'codeblock-content';

    const lineNumbers = preElement.querySelector('.line-numbers');
    if (lineNumbers) {
      contentWrapper.appendChild(lineNumbers);
    }
    contentWrapper.appendChild(codeBlock);

    preElement.innerHTML = '';
    preElement.appendChild(header);
    preElement.appendChild(contentWrapper);
  });
});

function createCopyButton(codeBlock) {
  const button = document.createElement('button');
  button.className = 'codeblock-tool copy-button';
  button.textContent = 'Copy';

  button.addEventListener('click', function () {
    const code = codeBlock.textContent;
    navigator.clipboard.writeText(code).then(function () {
      button.textContent = 'Copied!';
      setTimeout(function () {
        button.textContent = 'Copy';
      }, 2000);
    });
  });

  return button;
}

function createTryRubyButton(codeBlock) {
  const button = document.createElement('a');
  button.href = `http://try.ruby-lang.org/playground/#code=${encodeURIComponent(codeBlock.textContent)}`;
  button.className = 'codeblock-tool try-ruby-button';
  button.textContent = 'Try in Ruby Playground';
  button.target = '_blank';

  return button;
} 