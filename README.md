# Unique Content Set

Check for uniquely created content in a Redis set.

## INSTALL

    gem install unique_content_set

## USAGE

    # uses a Redis Set named something like "unique:5:messages"
    set = UniqueContentSet user.id, :messages

    if set.add(@message.body, @message.created_at)
      # this message body has been posted before, do something!
    end

    if set.exist?(@message.body)
      # this message body has been posted before, do something!
    end

    # Purge old message content.
    set.delete_before(1.month.ago)

## Contribute

If you'd like to hack on UniqueContentSet, start by forking the repo on GitHub:

`https://github.com/technoweenie/unique_content_set`

The best way to get your changes merged back into core is as follows:

* Clone down your fork
* Create a thoughtfully named topic branch to contain your change
* Hack away
* Add tests and make sure everything still passes by running rake
* If you are adding new functionality, document it in the README
* Do not change the version number, I will do that on my end
* If necessary, rebase your commits into logical chunks, without errors
* Push the branch up to GitHub
* Send a pull request to the `technoweenie/unique_content_set` project.

