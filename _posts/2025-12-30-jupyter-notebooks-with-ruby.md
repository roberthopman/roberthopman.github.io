---
layout: post
title:  "Jupyter Notebooks with Ruby"
date: 2025-12-30
excerpt: "How to set up Jupyter notebooks with Ruby using IRuby, and embed them in blog posts."
tags: [ruby, jupyter, tutorial, workflow]
---

This post documents how to set up Jupyter notebooks with Ruby support and embed them in blog posts.

## Pre-conditions

```bash
gem install iruby
iruby register --force
brew install jupyter
```

Later, you can check the installed versions of IRuby with:
```bash
for version in $(rbenv versions --bare); do echo "=== Ruby $version ===" && RBENV_VERSION=$version gem list iruby 2>/dev/null | grep -E "^iruby" || echo "iruby not installed"; done
```

Local usage:
```bash
jupyter lab
```

Webbrowser usage: [http://localhost:8888/lab](http://localhost:8888/lab)

## Workflow

1. Create your notebook (`.ipynb` file) - either via Jupyter Lab or by writing the JSON directly

2. Convert to HTML:

```bash
/opt/homebrew/opt/jupyterlab/bin/jupyter nbconvert --to html notebooks/your-notebook.ipynb
```

3. Extract the `<main>` content from the generated HTML

4. Add the Jupyter CSS to your site's stylesheet (see `assets/css/codeblock.css`)

5. Embed the HTML directly in your blog post

## Example

<div class="jp-Notebook">
  <div class="jp-Cell jp-MarkdownCell jp-Notebook-cell">
    <div class="jp-Cell-inputWrapper">
      <div class="jp-InputArea jp-Cell-inputArea">
        <div class="jp-InputPrompt jp-InputArea-prompt"></div>
        <div class="jp-RenderedMarkdown">
          <h3>stdout</h3>
          <p><code>puts</code> writes to stdout:</p>
        </div>
      </div>
    </div>
  </div>
  <div class="jp-Cell jp-CodeCell jp-Notebook-cell">
    <div class="jp-Cell-inputWrapper">
      <div class="jp-InputArea jp-Cell-inputArea">
        <div class="jp-InputPrompt jp-InputArea-prompt">In [1]:</div>
        <div class="jp-InputArea-editor">
          <div class="highlight hl-ruby">
            <pre><span class="nb">puts</span> <span class="s2">"This is stdout"</span></pre>
          </div>
        </div>
      </div>
    </div>
    <div class="jp-Cell-outputWrapper">
      <div class="jp-OutputArea jp-Cell-outputArea">
        <div class="jp-OutputArea-child">
          <div class="jp-OutputPrompt jp-OutputArea-prompt"></div>
          <div class="jp-RenderedText jp-OutputArea-output" data-mime-type="text/plain">
            <pre>This is stdout</pre>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div class="jp-Cell jp-MarkdownCell jp-Notebook-cell">
    <div class="jp-Cell-inputWrapper">
      <div class="jp-InputArea jp-Cell-inputArea">
        <div class="jp-InputPrompt jp-InputArea-prompt"></div>
        <div class="jp-RenderedMarkdown">
          <h3>stderr</h3>
          <p>Two ways to write to stderr:</p>
        </div>
      </div>
    </div>
  </div>
  <div class="jp-Cell jp-CodeCell jp-Notebook-cell">
    <div class="jp-Cell-inputWrapper">
      <div class="jp-InputArea jp-Cell-inputArea">
        <div class="jp-InputPrompt jp-InputArea-prompt">In [2]:</div>
        <div class="jp-InputArea-editor">
          <div class="highlight hl-ruby">
            <pre><span class="nb">warn</span> <span class="s2">"Using warn"</span></pre>
          </div>
        </div>
      </div>
    </div>
    <div class="jp-Cell-outputWrapper">
      <div class="jp-OutputArea jp-Cell-outputArea">
        <div class="jp-OutputArea-child">
          <div class="jp-OutputPrompt jp-OutputArea-prompt"></div>
          <div class="jp-RenderedText jp-OutputArea-output" data-mime-type="application/vnd.jupyter.stderr">
            <pre>Using warn</pre>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div class="jp-Cell jp-CodeCell jp-Notebook-cell">
    <div class="jp-Cell-inputWrapper">
      <div class="jp-InputArea jp-Cell-inputArea">
        <div class="jp-InputPrompt jp-InputArea-prompt">In [3]:</div>
        <div class="jp-InputArea-editor">
          <div class="highlight hl-ruby">
            <pre><span class="vg">$stderr</span><span class="o">.</span><span class="n">puts</span> <span class="s2">"Using $stderr.puts"</span></pre>
          </div>
        </div>
      </div>
    </div>
    <div class="jp-Cell-outputWrapper">
      <div class="jp-OutputArea jp-Cell-outputArea">
        <div class="jp-OutputArea-child">
          <div class="jp-OutputPrompt jp-OutputArea-prompt"></div>
          <div class="jp-RenderedText jp-OutputArea-output" data-mime-type="application/vnd.jupyter.stderr">
            <pre>Using $stderr.puts</pre>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div class="jp-Cell jp-MarkdownCell jp-Notebook-cell">
    <div class="jp-Cell-inputWrapper">
      <div class="jp-InputArea jp-Cell-inputArea">
        <div class="jp-InputPrompt jp-InputArea-prompt"></div>
        <div class="jp-RenderedMarkdown">
          <h3>Return value</h3>
          <p>The last expression's value shows with Out label:</p>
        </div>
      </div>
    </div>
  </div>
  <div class="jp-Cell jp-CodeCell jp-Notebook-cell">
    <div class="jp-Cell-inputWrapper">
      <div class="jp-InputArea jp-Cell-inputArea">
        <div class="jp-InputPrompt jp-InputArea-prompt">In [4]:</div>
        <div class="jp-InputArea-editor">
          <div class="highlight hl-ruby">
            <pre><span class="s2">"This is a return value"</span></pre>
          </div>
        </div>
      </div>
    </div>
    <div class="jp-Cell-outputWrapper">
      <div class="jp-OutputArea jp-Cell-outputArea">
        <div class="jp-OutputArea-child">
          <div class="jp-OutputPrompt jp-OutputArea-prompt">Out[4]:</div>
          <div class="jp-RenderedText jp-OutputArea-output" data-mime-type="text/plain">
            <pre>"This is a return value"</pre>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div class="jp-Cell jp-MarkdownCell jp-Notebook-cell">
    <div class="jp-Cell-inputWrapper">
      <div class="jp-InputArea jp-Cell-inputArea">
        <div class="jp-InputPrompt jp-InputArea-prompt"></div>
        <div class="jp-RenderedMarkdown">
          <h3>All three together</h3>
          <p>Output order: stdout, stderr, then return value:</p>
        </div>
      </div>
    </div>
  </div>
  <div class="jp-Cell jp-CodeCell jp-Notebook-cell">
    <div class="jp-Cell-inputWrapper">
      <div class="jp-InputArea jp-Cell-inputArea">
        <div class="jp-InputPrompt jp-InputArea-prompt">In [5]:</div>
        <div class="jp-InputArea-editor">
          <div class="highlight hl-ruby">
            <pre><span class="nb">puts</span> <span class="s2">"1. stdout via puts"</span>
<span class="nb">warn</span> <span class="s2">"2. stderr via warn"</span>
<span class="vg">$stderr</span><span class="o">.</span><span class="n">puts</span> <span class="s2">"3. stderr via $stderr.puts"</span>
<span class="s2">"4. return value"</span></pre>
          </div>
        </div>
      </div>
    </div>
    <div class="jp-Cell-outputWrapper">
      <div class="jp-OutputArea jp-Cell-outputArea">
        <div class="jp-OutputArea-child">
          <div class="jp-OutputPrompt jp-OutputArea-prompt"></div>
          <div class="jp-RenderedText jp-OutputArea-output" data-mime-type="text/plain">
            <pre>1. stdout via puts</pre>
          </div>
        </div>
        <div class="jp-OutputArea-child">
          <div class="jp-OutputPrompt jp-OutputArea-prompt"></div>
          <div class="jp-RenderedText jp-OutputArea-output" data-mime-type="application/vnd.jupyter.stderr">
            <pre>2. stderr via warn
3. stderr via $stderr.puts</pre>
          </div>
        </div>
        <div class="jp-OutputArea-child">
          <div class="jp-OutputPrompt jp-OutputArea-prompt">Out[5]:</div>
          <div class="jp-RenderedText jp-OutputArea-output" data-mime-type="text/plain">
            <pre>"4. return value"</pre>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>



