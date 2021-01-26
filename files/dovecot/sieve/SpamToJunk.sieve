require "copy";
require "mailbox";
require "imap4flags";
require "fileinto";

# rule:[Send SPAM to Junk]
if header :contains "X-Spam-Flag" "YES"
{
   fileinto :create "Junk";
   stop;
}
