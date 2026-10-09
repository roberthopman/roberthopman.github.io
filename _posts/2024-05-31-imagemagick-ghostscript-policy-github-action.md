---
layout: post
title:  "Fixing an error of ImageMagick in GitHub Actions"
excerpt: "Fix ImageMagick PDF conversion errors in GitHub Actions by installing Ghostscript and updating the ImageMagick policy configuration."
tags: [imagemagick, github-actions, troubleshooting, ci-cd]
---

When using ImageMagick in GitHub Actions, you may encounter the following error:

```sh
MiniMagick::Error: `convert -density 300 -quality 90 /home/runner/.../foobar.pdf[0] 
-resize 500x500> /home/runner/.../thumbnail/foobar.jpg 
failed with error: convert-im6.q16: no images defined 
`/home/runner/.../thumbnail/foobar.jpg' @ error/convert.c/ConvertImageCommand/3229.
```

The checks and fixes that lead from the error to a working convert:

![A flowchart that starts at a failed convert with the error no images defined. The first check asks if the policy allows the PDF coder. If not, a step edits policy.xml and the flow retries. The second check asks if Ghostscript is installed. If not, a step installs Ghostscript and the flow retries. When both checks pass, convert succeeds and writes the thumbnail.](/assets/images/imagemagick-ghostscript-policy-github-action-recap.svg)

Observing a possible solution here: [https://github.com/orgs/community/discussions/26600](https://github.com/orgs/community/discussions/26600)

To verify, I looked at: 
- the version of ImageMagick
- the policy.xml file
- adding ghostscript (this was the missing step in my case)

Final solution, including for reference the debugging steps, in a GitHub Action workflow file:

```yml
jobs:
  the_job_name:
    runs-on: ubuntu-latest
    steps:
      - name: Install ghostscript
        run: sudo apt install ghostscript
      - name: Install ImageMagick
        run: |
          sudo apt-get update
          sudo apt-get install -y imagemagick
      - name: Set up ImageMagick policy
        run: |
          sudo sed -i 's/<policy domain="coder" rights="none" pattern="PDF"/<policy domain="coder" rights="read|write" pattern="PDF"/' /etc/ImageMagick-6/policy.xml
      - name: Debugging ImageMagick version
        run: |
          echo "debug 'convert -version'"
          convert -version
      - name: Debugging ImageMagick policy
        run: |
          echo "debug 'cat /etc/ImageMagick-6/policy.xml'"
          cat /etc/ImageMagick-6/policy.xml
```    