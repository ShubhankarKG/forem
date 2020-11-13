class EmgithubTag < LiquidTagBase
  PARTIAL = "liquids/emgithub".freeze
  OPTION_REGEXP = /\A(showBorder|showLineNumbers|showFileMeta)*\z/.freeze
  LINK_REGEXP = %r{\A(http|https)://github.com/\w+/[a-zA-Z0-9-]+/blob/[a-zA-Z0-9_./#-]*\z}.freeze

  def initialize(_tag_name, link, _parse_context)
    super
    @link = parse_link(link)
    @build_options = parse_options
  end

  def render(_context)
    ApplicationController.render(
      partial: PARTIAL,
      locals: {
        link: @link,
        build_options: @build_options,
        height: 600
      },
    )
  end

  private

  def valid_option(option)
    option.match(OPTION_REGEXP)
  end

  def parse_options
    options = %w[showBorder showLineNumbers showFileMeta]
    options.join("=on&")
  end

  def parse_link(link)
    stripped_link = ActionController::Base.helpers.strip_tags(link)
    the_link = stripped_link.split(" ").first
    raise StandardError, "Invalid GitHub URL" unless valid_link?(the_link)

    CGI.escape(the_link)
  end

  def valid_link?(link)
    link_no_space = link.delete(" ")
    link_no_space.match?(LINK_REGEXP)
  end
end

Liquid::Template.register_tag("emgithub", EmgithubTag)