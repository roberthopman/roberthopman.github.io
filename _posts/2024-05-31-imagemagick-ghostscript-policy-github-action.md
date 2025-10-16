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