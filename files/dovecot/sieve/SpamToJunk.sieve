require "fileinto";
require "mailbox";

# rule:[Send SPAM to Junk]
if header :contains "X-Spam-Flag" "YES"
{
   fileinto :create "Junk";
   stop;
}
