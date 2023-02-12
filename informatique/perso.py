"""
    pygments.styles.perso
    ~~~~~~~~~~~~~~~~~~~~~
"""

from pygments.style import Style
from pygments.token import Keyword, Name, Comment, String, Error, Token, \
     Number, Operator, Generic, Whitespace, Punctuation, Other, Literal

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

        Comment:                   "#7d7d7d", # class: 'c'
        Comment.Multiline:         "",        # class: 'cm'
        Comment.Preproc:           "",        # class: 'cp'
        Comment.Single:            "",        # class: 'c1'
        Comment.Special:           "",        # class: 'cs'

        Keyword:                   "bold #0095a0", # class: 'k'
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
        Name.Class:                "", # class: 'nc' - to be revised
        Name.Constant:             "", # class: 'no' - to be revised
        Name.Decorator:            "", # class: 'nd' - to be revised
        Name.Entity:               "",        # class: 'ni'
        Name.Exception:            "", # class: 'ne'
        Name.Function:             "", # class: 'nf'
        Name.Property:             "",        # class: 'py'
        Name.Label:                "",        # class: 'nl'
        Name.Namespace:            "#116084", # class: 'nn' - to be revised
        Name.Other:                "", # class: 'nx'
        Name.Tag:                  "", # class: 'nt' - like a keyword
        Name.Variable:             "",        # class: 'nv' - to be revised
        Name.Variable.Class:       "",        # class: 'vc' - to be revised
        Name.Variable.Global:      "",        # class: 'vg' - to be revised
        Name.Variable.Instance:    "",        # class: 'vi' - to be revised

        Number:                    "#2060ff", # class: 'm'
        Number.Float:              "",        # class: 'mf'
        Number.Hex:                "",        # class: 'mh'
        Number.Integer:            "",        # class: 'mi'
        Number.Integer.Long:       "",        # class: 'il'
        Number.Oct:                "",        # class: 'mo'

        Literal:                   "#ae81ff", # class: 'l'
        Literal.Date:              "#e6db74", # class: 'ld'

        String:                    "#06bc0d", # class: 's'
        String.Backtick:           "",        # class: 'sb'
        String.Char:               "",        # class: 'sc'
        String.Doc:                "",        # class: 'sd' - like a comment
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
        Generic.Inserted:          "#a6e22e", # class: 'gi'
        Generic.Output:            "#66d9ef", # class: 'go'
        Generic.Prompt:            "bold #f92672", # class: 'gp'
        Generic.Strong:            "bold",    # class: 'gs'
        Generic.Subheading:        "#75715e", # class: 'gu'
        Generic.Traceback:         "",        # class: 'gt'
    }
