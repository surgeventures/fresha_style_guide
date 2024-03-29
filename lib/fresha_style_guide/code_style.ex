defmodule FreshaStyleGuide.CodeStyle do
  @moduledoc """
  Basic code style and formatting guidelines.
  """

  @doc """
  Inline blocks should be preferred for simple code that fits one line.

  ## Reasoning

  In case of simple and small functions, conditions etc, the inline variant of block allows to keep
  code more compact and fit biggest piece of the story on the screen without losing readability.

  ## Examples

  Preferred:

      def add_two(number), do: number + 2

  Wasted vertical space:

      def add_two(number) do
        number + 2
      end

  Too long (or too complex) to be inlined:

      def add_two_and_multiply_by_the_meaning_of_life_and_more(number),
        do: (number + 2) * 42 * get_more_for_this_truly_crazy_computation(number)

  """
  def inline_block_usage, do: nil

  @doc """
  Single blank line must be inserted after `@moduledoc`.

  ## Reasoning

  `@moduledoc` is a module-wide introduction to the module. It makes sense to give it padding and
  separate it from what's coming next. The reverse looks especially bad when followed by a function
  that has no `@doc` clause yet.

  ## Examples

  Preferred:

      defmodule SuperMod do
        @moduledoc \"""
        This module is seriously amazing.
        \"""

        def call, do: nil
      end

  `@moduledoc` that pretends to be a `@doc`:

      defmodule SuperMod do
        @moduledoc \"""
        This module is seriously amazing.
        \"""
        def call, do: nil
      end

  """
  def moduledoc_spacing, do: nil

  @doc """
  There must be no blank lines between `@doc` and the function definition.

  ## Reasoning

  Compared to moduledoc spacing, the `@doc` clause belongs to the function
  definition directly beneath it, so the lack of blank line between the two is there to make this
  linkage obvious. If the blank line is there, there's a growing risk of `@doc` clause becoming
  completely separated from its owner in the heat of future battles.

  ## Examples

  Preferred:

      @doc \"""
      This is by far the most complex function in the universe.
      \"""
      def func, do: nil

  Weak linkage:

      @doc \"""
      This is by far the most complex function in the universe.
      \"""

      def func, do: nil

  Broken linkage:

      @doc \"""
      This is by far the most complex function in the universe.
      \"""

      def non_complex_func, do: something_less_complex_than_returning_nil()

      def func, do: nil

  """
  def doc_spacing, do: nil

  @doc """
  Per-function usage of reuse directives should be preferred over module-wide usage.

  ## Reasoning

  If a need for `alias`, `import` or `require` spans only across single function in a module (or
  across a small subset of functions in otherwise large module), it should be preferred to declare
  it locally on top of that function instead of globally for whole module.

  Keeping these declarations local makes them even more descriptive as to what scope is really
  affected. They're also more visible, being closer to the place they're used at. The chance for
  conflicts is also reduced when they're local.

  ## Examples

  Preferred (`alias` on `Users.User` is used in both `create` and `delete` functions so it's made
  global, but `import` on `Ecto.Query` is only used in `delete` function so it's declared only
  there):

      defmodule Users do
        alias Users.User

        def create(params)
          %User{}
          |> User.changeset(params)
          |> Repo.insert()
        end

        def delete(user_id) do
          import Ecto.Query

          Repo.delete_all(from users in User, where: users.id == ^user_id)
        end
      end

  Not so DRY (still, this could be OK if there would be more functions in `Users` module that
  wouldn't use the `User` sub-module):

      defmodule Users do
        def create(params)
          alias Users.User

          %User{}
          |> User.changeset(params)
          |> Repo.insert()
        end

        def delete(user_id) do
          import Ecto.Query
          alias Users.User

          Repo.delete_all(from users in User, where: users.id == ^user_id)
        end
      end

  Everything a bit too public:

      defmodule Users do
        import Ecto.Query
        alias Users.User

        def create(params)
          %User{}
          |> User.changeset(params)
          |> Repo.insert()
        end

        def delete(user_id) do
          Repo.delete_all(from users in User, where: users.id == ^user_id)
        end
      end

  """
  def reuse_directive_scope, do: nil

  @doc """
  Reuse directives should be placed on top of modules or functions.

  ## Reasoning

  Calls to `alias`, `import`, `require` or `use` should be placed on top of module or function, or
  directly below `@moduledoc` in case of modules with documentation.

  Just like with the order rule, this is to make finding these directives faster when reading the
  code. For that reason, it's more beneficial to have such important key for interpreting code in
  obvious place than attempting to have them right above the point where they're needed (which
  usually ends up messed up anyway when code gets changed over time).

  ## Examples

  Preferred:

      defmodule Users do
        alias Users.User

        def name(user) do
          user["name"] || user.name
        end

        def delete(user_id) do
          import Ecto.Query

          user_id = String.to_integer(user_id)
          Repo.delete_all(from users in User, where: users.id == ^user_id)
        end
      end

  Cool yet not so future-proof "lazy" placement:

      defmodule Users do
        def name(user) do
          user["name"] || user.name
        end

        alias Users.User

        def delete(user_id) do
          user_id = String.to_integer(user_id)

          import Ecto.Query

          Repo.delete_all(from users in User, where: users.id == ^user_id)
        end
      end

  """
  def reuse_directive_placement, do: nil

  @doc """
  Calls to reuse directives should be placed in `use`, `require`, `import`,`alias` order.

  ## Reasoning

  First of all, having any directive ordering convention definitely beats not having one, since they
  are a key to parsing code and so it adds up to better code reading experience when you know
  exactly where to look for an alias or import.

  This specific order is an attempt to introduce more significant directives before more trivial
  ones. It so happens that in case of reuse directives, the reverse alphabetical order does exactly
  that, starting with `use` (which can do virtually anything with a target module) and ending with
  `alias` (which is only a cosmetic change and doesn't affect the module's behavior).

  ## Examples

  Preferred:

      use Helpers.Thing
      import Helpers.Other
      alias Helpers.Tool

  Out of order:

      alias Helpers.Tool
      import Helpers.Other
      use Helpers.Thing

  """
  def reuse_directive_order, do: nil

  @doc """
  Calls to reuse directives should not be separated with blank lines.

  ## Reasoning

  It may be tempting to separate all aliases from imports with blank line or to separate multi-line
  grouped aliases from other aliases, but as long as they're properly placed and ordered, they're
  readable enough without such extra efforts. Also, as their number grows, it's more beneficial to
  keep them vertically compact than needlessly padded.

  ## Examples

  Preferred:

      use Helpers.Thing
      import Helpers.Other
      alias Helpers.Subhelpers.{
        First,
        Second
      }
      alias Helpers.Tool

  Too much padding (with actual code starting N screens below):

      use Helpers.Thing

      import Helpers.Other

      alias Helpers.Subhelpers.{
        First,
        Second
      }

      alias Helpers.Tool

  """
  def reuse_directive_spacing, do: nil

  @doc """
  Controller actions should be placed in `I S N C E U D` order in controllers and their tests.

  ## Reasoning

  It's important to establish a consistent order to make it easier to find actions and their tests,
  considering that both controller and (especially) controller test files tend to be big at times.

  This particular order (`index`, `show`, `new`, `create`, `edit`, `update`, `delete`) comes from
  the long-standing convention established by both Phoenix and, earlier, Ruby on Rails generators,
  so it should be familiar, predictable and non-surprising to existing developers.

  ## Examples

  Preferred:

      defmodule MyProject.Web.UserController do
        use MyProject.Web, :controller

        def index(_conn, _params), do: raise("Not implemented")

        def show(_conn, _params), do: raise("Not implemented")

        def new(_conn, _params), do: raise("Not implemented")

        def create(_conn, _params), do: raise("Not implemented")

        def edit(_conn, _params), do: raise("Not implemented")

        def update(_conn, _params), do: raise("Not implemented")

        def delete(_conn, _params), do: raise("Not implemented")
      end

  Different (CRUD-like) order against the convention:

      defmodule MyProject.Web.UserController do
        use MyProject.Web, :controller

        def index(_conn, _params), do: raise("Not implemented")

        def new(_conn, _params), do: raise("Not implemented")

        def create(_conn, _params), do: raise("Not implemented")

        def show(_conn, _params), do: raise("Not implemented")

        def edit(_conn, _params), do: raise("Not implemented")

        def update(_conn, _params), do: raise("Not implemented")

        def delete(_conn, _params), do: raise("Not implemented")
      end

  > The issue with CRUD order is that `index` action falls between fitting and being kind of "above"
    the *Read* section and `new`/`edit` actions fall between *Read* and *Create*/*Update* sections,
    respectively.

  """
  def controller_action_order, do: nil

  @doc """
  Documentation in `@doc` and `@moduledoc` should start with an one-line summary sentence.

  ## Reasoning

  This first line is treated specially by ExDoc in that it's taken as a module/function summary for
  API summary listings. The period at its end is removed so that it looks good both as a summary
  (without the period) and as part of a whole documentation (with a period).

  The single-line limit (with up to 100 characters as per line limit rule) is there to avoid mixing
  up short and very long summaries on a single listing.

  It's also important to fit as precise description as possible in this single line, without
  unnecessarily repeating what's already expressed in the module or function name itself.

  ## Examples

  Preferred:

      defmodule MyProject.Accounts do
        @moduledoc \"""
        User account authorization and management system.
        \"""
      end

  Too vague:

      defmodule MyProject.Accounts do
        @moduledoc \"""
        Accounts system.
        \"""
      end

  Missing trailing period:

      defmodule MyProject.Accounts do
        @moduledoc \"""
        Accounts system
        \"""
      end

  Missing trailing blank line:

      defmodule MyProject.Accounts do
        @moduledoc \"""
        User account authorization and management system.
        All functions take the `MyProject.Accounts.Input` structure as input argument.
        \"""
      end

  """
  def doc_summary_format, do: nil

  @doc """
  Documentation in `@doc` and `@moduledoc` should be written in ExDoc-friendly Markdown.

  Here's what is considered an ExDoc-friendly Markdown:

  - Paragraphs written with full sentences, separated by a blank line

  - Headings starting from 2nd level heading (`## Biggest heading`)

  - Bullet lists starting with a dash and subsequent lines indented by 2 spaces

  - Bullet/ordered list items separated by a blank line

  - Elixir code indented by 4 spaces to mark the code block

  ## Reasoning

  This syntax is encouraged in popular Elixir libraries, it's confirmed to generate nicely readable
  output and it's just as readable in the code which embeds it as well.

  ## Examples

  Preferred:

      defmodule MyProject.Accounts do
        @moduledoc \"""
        User account authorization and management system.

        This module does truly amazing stuff. It's purpose is to take anything you pass its way and
        make an user out of that. It can also tell you if specific user can do specific things without
        messing the system too much.

        Here's what you can expect from this module:

        - Nicely written lists with a lot of precious information that
          get indented properly in every subsequent line

        - And that are well padded as well

        And here's an Elixir code example:

            defmodule MyProject.Accounts.User do
              @defstruct [:name, :email]
            end

        It's all beautiful, isn't it?
        \"""
      end

  Messed up line breaks, messed up list item indentation and non ExDoc-ish code block:

      defmodule MyProject.Accounts do
        @moduledoc \"""
        User account authorization and management system.

        This module does truly amazing stuff. It's purpose is to take anything you pass its way and
        make an user out of that. It can also tell you if specific user can do specific things without
        messing the system too much.
        Here's what you can expect from this module:

        - Nicely written lists with a lot of precious information that
        get indented properly in every subsequent line
        - And that are well padded as well

        And here's an Elixir code example:

        ```
        defmodule MyProject.Accounts.User do
          @defstruct [:name, :email]
        end
        ```

        It's not so beautiful, is it?
        \"""
      end

  """
  def doc_content_format, do: nil

  @doc """
  Config calls should be placed in alphabetical order, with modules over atoms.

  ## Reasoning

  Provides obvious and predictable placement of specific config calls.

  ## Examples

  Preferred:

      config :another_package, key: value
      config :my_project, MyProject.A, key: "value"
      config :my_project, MyProject.B, key: "value"
      config :my_project, :a, key: "value"
      config :my_project, :b, key: "value"
      config :package, key: "value"

  Modules wrongly mixed with atoms and internal props wrongly before external ones:

      config :my_project, MyProject.A, key: "value"
      config :my_project, :a, key: "value"
      config :my_project, MyProject.B, key: "value"
      config :my_project, :b, key: "value"
      config :another_package, key: value
      config :package, key: "value"

  """
  def config_order, do: nil

  @doc ~S"""
  Exceptions should define semantic struct fields and a custom `message/1` function.

  ## Reasoning

  It's possible to define an exception with custom arguments and message by overriding the
  `exception/1` function and defining a standard `defexception [:message]` struct, but that yields
  to non-semantic exceptions that don't express their arguments in their structure. It also makes
  it harder (or at least inconsistent) to define multi-argument exceptions, which is simply a
  consequence of not having a struct defined for an actual struct.

  Therefore, it's better to define exceptions with a custom set of struct fields instead of a
  `message` field and to define a `message/1` function that takes those fields and creates an error
  message out of them.

  ## Examples

  Preferred:

      defmodule MyError do
        defexception [:a, :b]

        def message(%__MODULE__{a: a, b: b}) do
          "a: #{a}, b: #{b}"
        end
      end

      raise MyError, a: 1, b: 2

  Non-semantic error struct with unnamed fields in multi-argument call:

      defmodule MyError do
        defexception [:message]

        def exception({a, b}) do
          %__MODULE__{message: "a: #{a}, b: #{b}"}
        end
      end

      raise MyError, {1, 2}

  """
  def error_struct_impl, do: nil

  @doc """
  Hardcoded word (both string and atom) lists should be written using the `~w` sigil.

  ## Reasoning

  They're simply more compact and easier to read this way. They're also easier to extend. For long
  lists, line breaks can be applied without problems.

  ## Examples

  Preferred:

      ~w(one two three)
      ~w(one two three)a

  Harder to read:

      ["one", "two", "three"]
      [:one, :two, :three]

  """
  def word_list_format, do: nil

  @doc """
  Exception modules (and only them) should be named with the `Error` suffix.

  ## Reasoning

  Exceptions are a distinct kind of application entities, so it's good to emphasize that in their
  naming. Two most popular suffixes are `Exception` and `Error`. The latter was choosen for brevity.

  ## Examples

  Preferred:

      defmodule InvalidCredentialsError do
        defexception [:one, :other]
      end

  Invalid suffix:

      defmodule InvalidCredentialsException do
        defexception [:one, :other]
      end

  Usage of `Error` suffix for non-exception modules:

      defmodule Actions.HandleRegistrationError do
        # ...
      end

  """
  def error_name_suffix, do: nil

  @doc """
  Basic happy case in a test file or scope should be placed on top of other cases.

  ## Reasoning

  When using tests to understand how specific unit of code works, it's very handy to have the basic
  happy case placed on top of other cases.

  ## Examples

  Preferred:

      defmodule MyProject.Web.MyControllerTest do
        describe "index/2" do
          test "works for valid params" do
            # ...
          end

          test "fails for invalid params" do
            # ...
          end
        end
      end

  Out of order:

      defmodule MyProject.Web.MyControllerTest do
        describe "index/2" do
          test "fails for invalid params" do
            # ...
          end

          test "works for valid params" do
            # ...
          end
        end
      end

  """
  def test_happy_case_placement, do: nil

  @doc """
  Modules referenced in typespecs should be aliased.

  ## Reasoning

  When writing typespecs, it is often necessary to reference a module in some nested naming
  scheme. One could reference it with the absolute name, e.g. `Application.Accounting.Invoice.t`,
  but this makes typespecs rather lengthy.

  Using aliased modules makes typespecs easier to read and, as an added benefit, it allows for an
  in-front declaration of module dependencies. This way we can easily spot breaches in module
  isolation.

  ## Examples

  Preferred:

      alias VideoApp.Recommendations.{Rating, Recommendation, User}

      @spec calculate_recommendations(User.t, [Rating.t]) :: [Recommendation.t]
      def calculate_recommendations(user, ratings) do
        # ...
      end

  Way too long:

      @spec calculate_recommendations(
        VideoApp.Recommendations.User.t,
        [VideoApp.Recommendations.Rating.t]
      ) :: [VideoApp.Recommendations.Recommendation.t]
      def calculate_recommendations(user, ratings) do
        # ...
      end
  """
  def typespec_alias_usage, do: nil
end
