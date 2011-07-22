package AssetTagging::L10N::ja;
use strict;
use base 'AssetTagging::L10N';
use vars qw( %Lexicon );

our %Lexicon = (
    'Tagging the asset associated with the field.' => 'カスタムフィールドに関連付けられているアセットにタグ付けします。',
    'Relationship between basename of field tags' => 'カスタムフィールドのベースネームとタグの対応関係',
    'Format is basename:tag, and one line for each item.' => '書式は「basename:tagname」とし、1項目ごとに改行します。'
);

1;