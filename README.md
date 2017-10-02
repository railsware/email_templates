# Email Template Generator

It’s based on middleman using premailer. It's integrated with mailtrap for sending created email templates.

With its help you can:
- create email templates with different layouts and preview them in a browser;
- use sass when writing css assets. When template is build styles are converted to inline. Styles which can not be inlined (e.g media queries) are left in the style tag.
- send email template to your Mialtrap account and than to any other email client for testing.

Commands:
`middleman server`
`middleman build'
`ruby send_email.rb  {mailtrap inbox login} {mailtrap inbox password}`
