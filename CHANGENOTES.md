* Incremented version from 6.6.6 to 6.6.7 [cd12e51efb78c2e1af593b47b961c4ac8cd29a59](/../../commit/cd12e51efb78c2e1af593b47b961c4ac8cd29a59)

* Added CHANGENOTES [870d6e49f2ff9b43b1f84b49648969f67c497b82](/../../commit/870d6e49f2ff9b43b1f84b49648969f67c497b82)

* Deleted CHANGELOG.md [b412a5f66a4bd48b132ead94cf14fba6444c3b34](/../../commit/b412a5f66a4bd48b132ead94cf14fba6444c3b34)

* Fixed CoinQuery plugin not stripping queries. [15979d67920bbc4f586e3036a0a003302f54404b](/../../commit/15979d67920bbc4f586e3036a0a003302f54404b)
  * This was in response to issue [#92](/../../issues/92)
  * Plugin is still left broken (see [#103](/../../issues/103))

* Changed CHANGENOTES to CHANGENOTES.md

* Fixed issue [#101](/../../issues/103)
  * Added new variable to hold stripped query
  * Added documentation to script
  * Changed regex hook to something more sane

* Updated CHANGENOTES.md 1/3/19

* Updated CHANGENOTES.md 1/3/19 (2)
  * Testing issue reference fix

* Updated CHANGENOTES.md 1/3/19 (3)
  * Issue reference fix worked, applying to rest of file.
  * Testing commit reference fix

#### dev6 - Push #1 1/3/19
* Updated CHANGENOTES.md
  * Moving forward will document pushes in blocks
* Updated fun.rb
  * Fixed issue [#95](/../../issues/95)
  * Changed watermark to relevant info

#### dev6 - Push #2 2/20/19
**Reason**: Bugfix, critical

* Updated .gitignore
 * Added userinfo.yaml
 * Added seen.yaml
 * Added memos.yaml
 * Dev Note on change: These files shouldn't exist as they interfere with first run of Eve.

* Removed docs/userinfo.yaml
* Removed docs/memos.yaml
* Removed docs/seen.yaml

* Updated CHANGENOTES.md to reflect changes

#### dev6 - Push #3 02/27/19
**Reason**: Bugfix (Critical)

* Updated Gemfile to require ruby 2.6.0 as it was requiring 2.6.1 previously

* Updated CHANGENOTES.md to reflect changes
