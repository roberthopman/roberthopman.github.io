document.addEventListener('DOMContentLoaded', function () {
  const codeBlocks = document.querySelectorAll('pre code');

  codeBlocks.forEach(function (codeBlock) {
    const preElement = codeBlock.parentNode;

    const header = document.createElement('div');
    header.className = 'codeblock-header';

    // Only add Try Ruby button for Ruby code blocks (before Copy)
    if (isRubyCode(codeBlock)) {
      const tryRubyButton = createTryRubyButton(codeBlock);
      header.appendChild(tryRubyButton);
    }

    const shareButton = createShareButton(codeBlock);
    header.appendChild(shareButton);

    const copyButton = createCopyButton(codeBlock);
    header.appendChild(copyButton);

    // Add AI assistant buttons
    const chatGptButton = createChatGptButton(codeBlock);
    header.appendChild(chatGptButton);

    const claudeButton = createClaudeButton(codeBlock);
    header.appendChild(claudeButton);

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

function isRubyCode(codeBlock) {
  // Check the code element itself
  const codeClass = codeBlock.className || '';
  if (codeClass.includes('language-ruby') || codeClass.includes('language-rb') || codeClass.includes('ruby')) {
    return true;
  }

  // Check parent elements (Jekyll puts language class on .highlighter-rouge wrapper)
  const wrapper = codeBlock.closest('.highlighter-rouge');
  if (wrapper) {
    const wrapperClass = wrapper.className || '';
    return wrapperClass.includes('language-ruby') || wrapperClass.includes('language-rb');
  }

  return false;
}

function createCopyButton(codeBlock) {
  const button = document.createElement('button');
  button.className = 'codeblock-tool copy-button';
  button.textContent = 'Copy';

  button.addEventListener('click', function () {
    const code = codeBlock.textContent;
    navigator.clipboard.writeText(code).then(function () {
      button.textContent = 'Copied';
      setTimeout(function () {
        button.textContent = 'Copy';
      }, 2000);
    });
  });

  return button;
}

function createTryRubyButton(codeBlock) {
  const button = document.createElement('a');
  button.href = `https://try.ruby-lang.org/playground/#code=${encodeURIComponent(codeBlock.textContent)}`;
  button.className = 'codeblock-tool try-ruby-button';
  button.textContent = 'Run';
  button.target = '_blank';

  return button;
}

function createShareButton(codeBlock) {
  const button = document.createElement('a');
  const language = getLanguage(codeBlock);
  const code = codeBlock.textContent;

  // Carbon.now.sh URL with code and language
  const params = new URLSearchParams({
    code: code,
    l: language,
    bg: 'rgba(248,248,248,1)',
    t: 'monokai',
    wt: 'none',
    ds: 'true',
    dsyoff: '20px',
    dsblur: '68px',
    wc: 'true',
    wa: 'true',
    ln: 'false',
    fl: '1',
    fm: 'SF Mono'
  });

  button.href = `https://carbon.now.sh/?${params.toString()}`;
  button.className = 'codeblock-tool share-button';
  button.textContent = 'Share';
  button.target = '_blank';

  return button;
}

function getLanguage(codeBlock) {
  // Check the code element itself
  const codeClass = codeBlock.className || '';
  const match = codeClass.match(/language-(\w+)/);
  if (match) return match[1];

  // Check parent wrapper
  const wrapper = codeBlock.closest('.highlighter-rouge');
  if (wrapper) {
    const wrapperMatch = wrapper.className.match(/language-(\w+)/);
    if (wrapperMatch) return wrapperMatch[1];
  }

  return 'auto';
}

function createChatGptButton(codeBlock) {
  const button = document.createElement('a');
  const code = codeBlock.textContent;
  const prompt = `Please read the following ruby syntax documentation and help me understand it:\n\n${code}`;

  button.href = `https://chatgpt.com/?q=${encodeURIComponent(prompt)}`;
  button.className = 'codeblock-tool chatgpt-button';
  button.textContent = 'Open in ChatGPT';
  button.target = '_blank';

  return button;
}

function createClaudeButton(codeBlock) {
  const button = document.createElement('a');
  const code = codeBlock.textContent;
  const prompt = `Please read the following ruby syntax documentation and help me understand it:\n\n${code}`;

  button.href = `https://claude.ai/new?q=${encodeURIComponent(prompt)}`;
  button.className = 'codeblock-tool claude-button';
  button.textContent = 'Open in Claude';
  button.target = '_blank';

  return button;
}