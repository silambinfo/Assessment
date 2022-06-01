/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* SendAmountDueDetails.cls Apex class to send emails using email template for charges calculated
* contacts records
* * ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Silambarasan Velu <silambinfo@gmail.com>
* @version        1.0
*/
public class SendAmountDueDetails {
    /**
  * ───────────────────────────────────────────────────────────────────────────────────────────────┐
  * sendEmail  apex method handles sending emails for received contacts
  * ────────────────────────────────────────────────────────────────────────────────────────────────
  * @param    List of contacts
  * @return   void - 
  * ───────────────────────────────────────────────────────────────────────────────────────────────┘
  */
    public static void sendEmail(List<Contact> con){
        try{
            List<Messaging.SingleEmailMessage> mails = new
            List<Messaging.SingleEmailMessage>();
            EmailTemplate template = [select id,subject,body,DeveloperName,HtmlValue from EmailTemplate where DeveloperName = 'Charging_Amount_Due_Mail'];
            for(Contact c : con){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setSubject(template.Subject);
                String body = template.HtmlValue;
                body = body.replace('[amtDue]',String.valueOf(c.Card_Value__c));
                mail.setHtmlBody(body);
                String []Address = new String[] { c.Email };
                mail.settoAddresses(Address);
                mails.add(mail);
            }
            Messaging.sendEmail(mails);
        }catch(Exception ex){
            throw new MotorCarIncException('Mail001','Failed while sending Email:'+ex.getMessage());
        }
    }
}
