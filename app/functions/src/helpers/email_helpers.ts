
import * as postmark from 'postmark';
import * as fs from 'fs';

export namespace EmailHelpers {

  /**
   * this is the global variable to store the template html so we only load it once
   */
  let _loadedTemplate: string|undefined = undefined;
    
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
      const templateContent = _loadedTemplate ? _loadedTemplate : fs.readFileSync("../constants/email_template.html").toString();
      if (!_loadedTemplate) {
        // setting this global so next time we don't load it
        _loadedTemplate = templateContent;
      }
      // now we have the content, but we need to replace a few things first
      let emailString = templateContent.replace("%%INSERT_TITLE%%", title);
      emailString = emailString.replace("%%INSERT_BODY%%", body);
      emailString = emailString.replace("%%INSERT_BUTTON_TEXT%%", buttonText);
      
      // connect to the proper API required to send an email using the postmark library
      const client = new postmark.ServerClient("POSTMARK_API_TEST");
      // and send the email
      const result = await client.sendEmail({
        //!TODO check the 'from' address from which to send these admin emails
        "From": "support@positiveplusone.com",
        "To": to,
        "Subject": subjectLine,
        "TextBody": emailString,
      });
      // return that the error code is equal to 0 - success
      return result && result.ErrorCode == 0;
    }
  }