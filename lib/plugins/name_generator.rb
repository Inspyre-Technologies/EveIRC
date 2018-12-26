# Author: taytaybabee
# Author: b0nk
# E-Mail: namaste@rawrnet.net

# This is your standard Google search plugin using the JSON API that Google
# provides. Please keep in mind that it can be a little spammy due to it
# providing the top three results of the query.

require_relative "config/check_ignore"

module Cinch::Plugins
    class NameGenerator
        include Cinch::Plugin

        set :plugin_name, "namegenerator"
        set :help, <<-USAGE.gsub(/^ {6}/, '')
        The Name Generator plugin helps you generate names.
        Usage:
        * !name-gen: This will allow you to generate a name. You can use the following flags; -vtn -tvn
        ** Explanation of flags:
        ** Most band names follow one of two formats: [Verb] the [Noun] or The [Verb] [Noun]. Using the
        ** band-name generator with no flags will make the bot choose randomly between the two formats.
        ** -vtn: [Verb] the [Noun] (ie Foster the People)
        ** -tvn: The [Verb] [Noun] (ie The Screaming Femmes)
        *** Example use:
        **** <namasteh> !name-gen -vtn
        **** <Eve> Your new band-name is: Resembled The Agency
        **** <namasteh> !name-gen
        **** <Eve> Your new band-name is: The Vexed Income
        USAGE

        match /name-gen( -vtn| -tvn)?/i

        def execute(m, nameFormat=nil)

            nameFormat = nameFormat.downcase unless nameFormat == nil

            case nameFormat
            when " -vtn"
              nameFormat = "vtn"
            when " -tvn"
                nameFormat = "tvn"
            when nil
                nameFormat = [
                    "vtn",
                    "tvn"
                ].sample
            end

            verb = File.readlines('docs/band_list_v.txt').sample
            verb = verb.chomp
            noun = File.readlines('docs/band_list_n.txt').sample
            noun = noun.chomp

            if nameFormat == "vtn"
                name = "#{verb} the #{noun}"
                result(m, name)
            end
            if nameFormat == "tvn"
                name = "The #{verb} #{noun}"
                result(m, name)
            end
            return

        end

        def result(m, name)
            name = name.titlecase
            m.reply "Your new band-name is: #{name}"
        end

    end

end