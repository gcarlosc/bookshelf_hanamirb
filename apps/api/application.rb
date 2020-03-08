require 'hanami/helpers'

module Api
  class Application < Hanami::Application
    configure do

      root __dir__

      load_paths << [
        'controllers',
        'views'
      ]

      routes 'config/routes'

      # Default format for the requests that don't specify an HTTP_ACCEPT header
      # Argument: A symbol representation of a mime type, defaults to :html
      #
      default_request_format :json

      # Default format for responses that don't consider the request format
      # Argument: A symbol representation of a mime type, defaults to :html
      #
      default_response_format :json

      ##
      # SECURITY
      #

      # X-Frame-Options is a HTTP header supported by modern browsers.
      # It determines if a web page can or cannot be included via <frame> and
      # <iframe> tags by untrusted domains.
      #
      # Web applications can send this header to prevent Clickjacking attacks.
      #
      # Read more at:
      #
      #   * https://developer.mozilla.org/en-US/docs/Web/HTTP/X-Frame-Options
      #   * https://www.owasp.org/index.php/Clickjacking
      #
      security.x_frame_options 'DENY'

      # X-Content-Type-Options prevents browsers from interpreting files as
      # something else than declared by the content type in the HTTP headers.
      #
      # Read more at:
      #
      #   * https://www.owasp.org/index.php/OWASP_Secure_Headers_Project#X-Content-Type-Options
      #   * https://msdn.microsoft.com/en-us/library/gg622941%28v=vs.85%29.aspx
      #   * https://blogs.msdn.microsoft.com/ie/2008/09/02/ie8-security-part-vi-beta-2-update
      #
      security.x_content_type_options 'nosniff'

      # X-XSS-Protection is a HTTP header to determine the behavior of the
      # browser in case an XSS attack is detected.
      #
      # Read more at:
      #
      #   * https://www.owasp.org/index.php/Cross-site_Scripting_(XSS)
      #   * https://www.owasp.org/index.php/OWASP_Secure_Headers_Project#X-XSS-Protection
      #
      security.x_xss_protection '1; mode=block'

      # Content-Security-Policy (CSP) is a HTTP header supported by modern
      # browsers. It determines trusted sources of execution for dynamic
      # contents (JavaScript) or other web related assets: stylesheets, images,
      # fonts, plugins, etc.
      #
      # Web applications can send this header to mitigate Cross Site Scripting
      # (XSS) attacks.
      #
      # The default value allows images, scripts, AJAX, fonts and CSS from the
      # same origin, and does not allow any other resources to load (eg object,
      # frame, media, etc).
      #
      # Inline JavaScript is NOT allowed. To enable it, please use:
      # "script-src 'unsafe-inline'".
      #
      # Content Security Policy introduction:
      #
      #  * http://www.html5rocks.com/en/tutorials/security/content-security-policy/
      #  * https://www.owasp.org/index.php/Content_Security_Policy
      #  * https://www.owasp.org/index.php/Cross-site_Scripting_%28XSS%29
      #
      # Inline and eval JavaScript risks:
      #
      #   * http://www.html5rocks.com/en/tutorials/security/content-security-policy/#inline-code-considered-harmful
      #   * http://www.html5rocks.com/en/tutorials/security/content-security-policy/#eval-too
      #
      # Content Security Policy usage:
      #
      #  * http://content-security-policy.com/
      #  * https://developer.mozilla.org/en-US/docs/Web/Security/CSP/Using_Content_Security_Policy
      #
      # Content Security Policy references:
      #
      #  * https://developer.mozilla.org/en-US/docs/Web/Security/CSP/CSP_policy_directives
      #
      security.content_security_policy %{
        form-action 'self';
        frame-ancestors 'self';
        base-uri 'self';
        default-src 'none';
        script-src 'self';
        connect-src 'self';
        img-src 'self' https: data:;
        style-src 'self' 'unsafe-inline' https:;
        font-src 'self';
        object-src 'none';
        plugin-types application/pdf;
        child-src 'self';
        frame-src 'self';
        media-src 'self'
      }

      ##
      # FRAMEWORKS
      #

      # Configure the code that will yield each time Web::Action is included
      # This is useful for sharing common functionality
      #
      # See: http://www.rubydoc.info/gems/hanami-controller#Configuration
      controller.prepare do
        # include MyAuthentication # included in all the actions
        # before :authenticate!    # run an authentication before callback
      end
    end

    ##
    # DEVELOPMENT
    #
    configure :development do
      # Don't handle exceptions, render the stack trace
      handle_exceptions false
    end

    ##
    # TEST
    #
    configure :test do
      # Don't handle exceptions, render the stack trace
      handle_exceptions false
    end

    ##
    # PRODUCTION
    #
    configure :production do
      # scheme 'https'
      # host   'example.org'
      # port   443

      assets do
        # Don't compile static assets in production mode (eg. Sass, ES6)
        #
        # See: http://www.rubydoc.info/gems/hanami-assets#Configuration
        compile false

        # Use fingerprint file name for asset paths
        #
        # See: https://guides.hanamirb.org/assets/overview
        fingerprint true

        # Content Delivery Network (CDN)
        #
        # See: https://guides.hanamirb.org/assets/content-delivery-network
        #
        # scheme 'https'
        # host   'cdn.example.org'
        # port   443

        # Subresource Integrity
        #
        # See: https://guides.hanamirb.org/assets/content-delivery-network/#subresource-integrity
        subresource_integrity :sha256
      end
    end
  end
end
