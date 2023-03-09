"""
    pygments.styles.perso
    ~~~~~~~~~~~~~~~~~~~~~
"""

from pygments.style import Style
from pygments.token import Keyword, Name, Comment, String, Error, Token, \
     Number, Operator, Generic, Whitespace, Punctuation, Other, Literal

from pygments.token import Keyword

class PersonalStyle(Style):
    """
    Personal color scheme.
    """

    background_color = "#FFF"
    highlight_color = "#FFF"

    styles = {
        # No corresponding class for the following:
        Token:                     "#f80095", # class:  ''
        Whitespace:                "",        # class: 'w'
        Error:                     "italic #d8902a", # class: 'err'
        Other:                     "",        # class 'x'

        Comment:                   "italic #7d7d7d", # class: 'c'
        Comment.Multiline:         "",        # class: 'cm'
        Comment.Preproc:           "",        # class: 'cp'
        Comment.Single:            "",        # class: 'c1'
        Comment.Special:           "",        # class: 'cs'

        Keyword:                   "#0095a0", # class: 'k'
        Keyword.Constant:          "",        # class: 'kc'
        Keyword.Declaration:       "",        # class: 'kd'
        Keyword.Namespace:         "", # class: 'kn'
        Keyword.Pseudo:            "",        # class: 'kp'
        Keyword.Reserved:          "",        # class: 'kr'
        Keyword.Type:              "",        # class: 'kt'

        Operator:                  "#a00000", # class: 'o'
        Operator.Word:             "",        # class: 'ow' - like keywords

        Punctuation:               "#000", # class: 'p'

        Name:                      "#0028ba", # class: 'n'
        Name.Attribute:            "", # class: 'na' - to be revised
        Name.Builtin:              "",        # class: 'nb'
        Name.Builtin.Pseudo:       "",        # class: 'bp'
        Name.Class:                "#0095a0", # class: 'nc' - to be revised
        Name.Constant:             "", # class: 'no' - to be revised
        Name.Decorator:            "", # class: 'nd' - to be revised
        Name.Entity:               "",        # class: 'ni'
        Name.Exception:            "#d05050", # class: 'ne'
        Name.Function:             "#a0a000", # class: 'nf'
        Name.Property:             "",        # class: 'py'
        Name.Label:                "",        # class: 'nl'
        Name.Namespace:            "#116084", # class: 'nn' - to be revised
        Name.Other:                "", # class: 'nx'
        Name.Tag:                  "", # class: 'nt' - like a keyword
        Name.Variable:             "#aa50aa",        # class: 'nv' - to be revised
        Name.Variable.Class:       "",        # class: 'vc' - to be revised
        Name.Variable.Global:      "",        # class: 'vg' - to be revised
        Name.Variable.Instance:    "",        # class: 'vi' - to be revised

        Number:                    "#2060ff", # class: 'm'
        Number.Float:              "#3075ff",        # class: 'mf'
        Number.Hex:                "",        # class: 'mh'
        Number.Integer:            "",        # class: 'mi'
        Number.Integer.Long:       "",        # class: 'il'
        Number.Oct:                "",        # class: 'mo'

        Literal:                   "", # class: 'l'
        Literal.Date:              "", # class: 'ld'

        String:                    "#06bc0d", # class: 's'
        String.Backtick:           "",        # class: 'sb'
        String.Char:               "",        # class: 'sc'
        String.Doc:                "#06900d",        # class: 'sd' - like a comment
        String.Double:             "",        # class: 's2'
        String.Escape:             "", # class: 'se'
        String.Heredoc:            "",        # class: 'sh'
        String.Interpol:           "",        # class: 'si'
        String.Other:              "",        # class: 'sx'
        String.Regex:              "",        # class: 'sr'
        String.Single:             "",        # class: 's1'
        String.Symbol:             "",        # class: 'ss'


        Generic:                   "",        # class: 'g'
        Generic.Deleted:           "#f92672", # class: 'gd',
        Generic.Emph:              "italic",  # class: 'ge'
        Generic.Error:             "",        # class: 'gr'
        Generic.Heading:           "",        # class: 'gh'
        Generic.Inserted:          "", # class: 'gi'
        Generic.Output:            "#66d9ef", # class: 'go'
        Generic.Prompt:            "#f92672", # class: 'gp'
        Generic.Strong:            "",    # class: 'gs'
        Generic.Subheading:        "#75715e", # class: 'gu'
        Generic.Traceback:         "",        # class: 'gt'
    }
