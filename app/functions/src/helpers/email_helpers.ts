
import * as postmark from 'postmark';
import { Keys } from '../constants/keys';

export namespace EmailHelpers {
    /**
   * function to send an email, formatted nicely with branding etc, from whoever, to whomever and containing what you want it to
   * @param to is the email (string) of who this is to be sent to
   * @param subjectLine is the subject line of the email 
   * @param title is the big title in the HTML content of the body
   * @param body is the texy body of the email (html) so include <br/> for line breaks etc
   * @param buttonText is the text to show in the button that is inluded in the email
   * @returns a promise of a boolean which will be true when successful and false when there was an error
   */
    export async function sendEmail(to: string, subjectLine: string, title: string, body: string, buttonText: string): Promise<boolean> {
      // using the ts library, we can keep this nice and simple
      // https://postmarkapp.com/developer/user-guide/send-email-with-api/send-a-single-email

      // first we have to load the template file we created for this email
      // but we are using a template from postmark cause we think that's probably better
      //
      // https://account.postmarkapp.com/servers/11935164/templates/33677731/edit#preview
      
      // connect to the proper API required to send an email using the postmark library
      const client = new postmark.ServerClient(Keys.PostmarkApiKey);
      // and send the email
      const result = await client.sendEmailWithTemplate({
        "From": "admin@positiveplusone.com",
        "TemplateId": 33677731,
        "To": to,
        "TemplateModel": {
          "product_url": "https://www.positiveplusone.com",
          "product_name": "Positive+1",
          "title": title,
          "body": body,
          "button_text": buttonText,
          "company_name": "Positive+1",
          "company_address": "First Floor, 2 Collingwood Street, Newcastle Upon Tyne, England, NE1 1JF",
          "action_url": "https://www.positiveplusone.com",
          "support_email": "support@positiveplusone.com",
          "sender_name": "Positive+1",
          "help_url": "https://www.positiveplusone.com/help",
          "mail_subject": subjectLine,
        }});
      // return that the error code is equal to 0 - success
      return result && result.ErrorCode == 0;
    }
  }