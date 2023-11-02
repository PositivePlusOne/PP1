import * as postmark from 'postmark';

export namespace EmailHelpers {
    /**
   * function to send an email, formatted nicely with branding etc, from whoever, to whomever and containing what you want it to
   * @param to is the email (string) of who this is to be sent to
   * @param subjectLine is the subject line of the email 
   * @param title is the big title in the HTML content of the body
   * @param body is the texy body of the email
   * @param bodyPostscript is any text you want to show after the support email portion of the email
   * @param buttonText is the text to show in the button that is inluded in the email
   * @param buttonActionUrl is the destination link that cilcking the button takes you to
   * @returns a promise of a boolean which will be true when successful and false when there was an error
   */
    export async function sendEmail(to: string,
                                    subjectLine: string,
                                    title: string,
                                    body: string,
                                    bodyPostscript: string,
                                    buttonText: string,
                                    buttonActionUrl: string): Promise<boolean> {
      // using the ts library, we can keep this nice and simple
      // https://postmarkapp.com/developer/user-guide/send-email-with-api/send-a-single-email

      // we are using a template from postmark cause we think that's probably better than loading our own content
      //
      // https://account.postmarkapp.com/servers/11935164/templates/33677731/edit#preview
      //
      // for safety - the template is also in the ./constants/template_email.html file so it's controlled in git
      
      // connect to the proper API required to send an email using the postmark library
      const apiKey = process.env.SMTP_API_SECRET;
      if (!apiKey) {
        throw new Error("SMTP_API_SECRET cannot be null.");
      }
      const client = new postmark.ServerClient(apiKey);
      // and send the email
      const result = await client.sendEmailWithTemplate({
        "From": "admin@positiveplusone.com",
        "TemplateId": 33677731,
        "To": to,
        "TemplateModel": {
          "title": title,
          "body": body,
          "body_postscript": bodyPostscript,
          "button_text": buttonText,
          "action_url": buttonActionUrl,
          "name": to,
          "product_name": "Positive+1",
          "support_email": "support@positiveplusone.com",
          "sender_name": "admin@positiveplusone.com",
          "help_url": "https://www.positiveplusone.com/help.html",
          "mail_subject": subjectLine,
        }});
      // return that the error code is equal to 0 - success
      return result && result.ErrorCode == 0;
    }
  }
  