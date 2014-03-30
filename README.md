# Bento

e-commerce application - © yafoy.com

## Get started

1. Customize ````/config/application.yml```
2. Copy and ```rename config/databse.yml.pg``` to ```config/database.yml```
2. ````rake db:bootstrap````
3. ````rails server -p 3015```` -> important for Stripe registered application
4. Sign in as admin and connect user with Stripe

## Webhook

1. Set webhook URL
2. Start redis