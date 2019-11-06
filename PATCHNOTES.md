# EveIRC Patch Notes

The following notes (should) will be updated with every new patch of Eve, going into and including eveSeven

## Why Patch Notes? We already have a CHANGELOG!?

There will (read: should) be a difference in the way developers log changes in CHANGELOG.md and PATCHNOTES.md

#### CHANGELOG.md
  * Detailed notes about every change, including commit IDs and information that can be off-putting to users who don't look at code all the time
  * CHANGELOG.md is being deprecated in favor of a new version change tracking system
  
#### PATCHNOTES.md
  * If a new feature is added upon use of a new patch PATCHNOTES.md will have - or at least have links to - documentation for that feature. No more searching code to find out what that new plugin does!
  * If your EveIRC installation will need special care after installing the patch this will be detailed in PATCHNOTES.md as well!
  * PATCHNOTES.md will contain important information about how to configure new features that the patch installs
  * PATCHNOTES.md will not be updated for Alpha (ie v6.5a0.1) or Beta (ie v6.5b2.1) release versions. Although, these versions might include a file with a similar use: TESTNOTES.md
  * Each release's patch will have it's own PATCHNOTES.md which has a scope that contains only the changes introduced between the last public version release and the commit containing the patchnotes.
  
    Old PATCHNOTES.md files will be moved into a new (as of this PATCHNOTES writing) directory: `EveIRC/patch_history` and will be named after the two versions between which changes it covers.
    
  * PATCHNOTES.md will contain notes from the developer to the user upgrading an existing version of EveIRC. This will become a feature of great importance when (if) eveSeven is released.
  * PATCHNOTES.md will always contain specific instructions for performing/installing that particular patch by the developer. No more guess work.
  * PATCHNOTES.md will provide an indication of the developer's assessment of the urgency of installing this patch. Here's an overview of the urgency levels:
    * CRITICAL: A patch marked with this tag usually contains fixes for security exploits or critical level bugfixes that restore core functionality to most/all copies.
    * IMPORTANT: A patch marked with this tag shouldn't be skipped  but if it is the consequences shouldn't be too dire. A patch will be marked with this tag any time the core system, admin system, or configuration workflow/system are modified.
    * NEGLIGIBLE: A patch marked with this tag will contain simple changes to EveIRC plugins, documentation, or help information. Can be ignored with no loss of application stability.
    * FEATURE: (This tag may be used in conjunction with others) A patch tagged with this label has one or more features (bits of usable functionality) that was not in the previous release. If this tag is used alone, that patch was only pushed to release the feature (though some negligible bugfixes might be contained)
    
## PATCHNOTES 6.10a1.06 [FEATURE (CONT)] 11/05/2019
  ## Release notes
    - ### File changes
    
## PATCHNOTES 6.10a1.05 [FEATURE] 11/05/2019
  - ### Release Notes
    * #### FEATURE - [App] - eveIRC Installer
      * ##### PURPOSE
        The eveIRC Installer will provide a greater scope of access to the eveIRC Bot by taking care of all steps of setting up one's environment.
        
      * ##### USAGE
        ``` shell
          taylor@quark:~/eveIRC/bin$ ruby installer/eve_install.rb
        
          # Screen is cleared and program starts

        ```
        

## PATCHNOTES 6.8.0 -> 6.9(rc1.0) [FEATURE] 08/02/19 (rc date)

  - ### Release Notes
    * #### Bugfixes (Negligible)
      * Made changes to Gemfile
      * Removed Ruby version restriction. Let us know if you are running older versions of Ruby and run into problems!
        * NOTE - It is IMPORTANT that you use Ruby 2.5.5 or greater for EveIRC. We will not support this, but it helps to know where a hard line may be.
      * Rearranged gem lines into alphabetical order
    
    * #### FEATURE
      * Added utilities plugin with one function thus far; converting temperatures between Celsius and Fahrenheit
      * ##### USAGE:            
                               
        ``` irc                
          <dave> !temp-to-f -40
          <Eve> -40°F          
          <dave> !temp-to-c -40
          <Eve> -40°C          
        ```                    
  
  - ### Installation
    * If you installed EveIRC using `bundle install` and chose the option where all plugins are installed for you, you don't have to take further action; the plugin should already be installed when you update from Github
  
    * If you chose the "picky install" then after pulling the new release from Github, find the folder EveIRC is actually run from. In the following example my  EveIRC git folder is `~/Documents/src/EveIRC` and I'm running the bot from `~/Documents/src/eveInstalled`
      * Firstly you'll want to copy the actual plugin file from the EveIRC github folder: 
        ``` console
        taylor@laptop:~$ cd Documents/src
        taylor@laptop:~/Documents/src$ cp EveIRC/lib/plugins/utilities.rb eveInstalled/lib/plugins/utilities.rb
        ```
        * Next you'll want to edit Eve.rb in the folder you run EveIRC from:
            
          ``` console
          taylor@laptop:~/Documents/src$ nano eveInstalled/Eve.rb
          ```
          You'll see a list of plugins, yours might be slightly different:
        
          ``` ruby
          c.plugins.plugins = [Cinch::Plugins::BotInfo,
                               Cinch::Plugins::PluginManagement,
                               Cinch::Plugins::Urban,
                               Cinch::Plugins::Help,
                               # ...
                               # plugin list continues...
                               # ...
                               Cinch::Plugins::NameGenerator]
          ```
        
          Just add the new Utilities plugin in the list. If you insert it at the end of the list do not forget to add a comma after the preceding plugin initialization. Like so:
        
          ``` ruby
          c.plugins.plugins = [Cinch::Plugins::BotInfo,
                               Cinch::Plugins::PluginManagement,
                               Cinch::Plugins::Urban,
                               Cinch::Plugins::Help,
                               # ...
                               # plugin list continues...
                               # ...
                               Cinch::Plugins::NameGenerator, # Note new comma
                               Cinch::Plugins::Utilities] # Add plugin, don't forget closing brace!
           ```
          _If you are using nano, Ctrl+x will exit the file. It will ask if you want to save. Hit 'y' and 'enter' when it asks you if you want to save it with that filename._
       * The final step is to add utilities.rb to the file load list:
        
        ``` console
        taylor@laptop:~/Documents/src$ nano bin/plugins.rb
        ```
        
          You will see a list of files that looks similar to this:
          
          ``` ruby
          require_relative "../lib/plugins/weather"
          #require_relative "../lib/plugins/google"
          require_relative "../lib/plugins/you_tube"
          #...cont....
          require_relative "../lib/plugins/news"
          require_relative "../lib/plugins/wolfram"
          require_relative "../lib/plugins/reddit"
          ```
          
          Just go ahead and add the file like so:
          
          ``` ruby
          require_relative "../lib/plugins/weather"
          #require_relative "../lib/plugins/google"
          require_relative "../lib/plugins/you_tube"
          #...cont....
          require_relative "../lib/plugins/news"
          require_relative "../lib/plugins/wolfram"
          require_relative "../lib/plugins/reddit"
          require_relative "../lib/plugins/utilities" # Note the new plugin!
          ```
         * Save, run `ruby Eve.rb` in the folder you usually do, and profit!
  - ### Changes since initial RC version:
    * #### Release v6.9(rc1.1)
      * ##### Bug fixes:
      * ##### Enhancements:
      * ##### Other:
        * Modified PATCHNOTES.md:
          * Fixed typo
          * Added notes for RC version bump
          * Reformatted for readability
        * Modified utilities.rb:
          * Removed un-needed require line
    * #### Release v6.9(rc1.2)
      * ##### Bug Fixes:
        * Modified lib/plugins/dictionary.rb
          * Added code to remove \<xref\> tags from returned results
    * #### Release v6.9(rc1.3)