---
layout: post
title:  "Collecting creditcard details in Stripe with SetupIntent"
excerpt: "Learn how to save customer payment credentials for future charges using Stripe's SetupIntent API with a Rails implementation example."
tags: [stripe, rails, payments, api, tutorial]
---

**What is a SetupIntent?**

SetupIntent is the process of saving a customer's payment credentials for future payments [source](https://stripe.com/docs/api/setup_intents). 

**Why is it important?**

As a business owner, you want to get creditcard details, in order to enable a [Payment](https://stripe.com/docs/api/payment_intents) in the future.

**How to implement it in Rails?**

I've looked at the [Sinatra implementation](https://github.com/stripe-samples/saving-card-without-payment/blob/master/server/ruby/server.rb) first. Used the [Stripe CLI](https://github.com/stripe/stripe-cli#installation) for the setup, made [a comment](https://github.com/stripe-samples/saving-card-without-payment/issues/13) about the setup which [was applied](https://github.com/stripe-samples/saving-card-without-payment/commit/38ccb926b53f07933cfe8f0b0bdf2923ba56130f#diff-b335630551682c19a781afebcf4d07bf978fb1f8ac04c6bf87428ed5106870f5R63-R66) to improve the README. The result is an experimental implementation [here](https://github.com/roberthopman/customer-centric).