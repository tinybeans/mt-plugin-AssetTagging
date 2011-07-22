package AssetTagging::Callbacks;

use strict;
use MT::ObjectAsset;
use MT::ObjectTag;
use MT::Entry;
use MT::Tag;

sub cms_pre_save_entry {
    my ($cb, $app, $obj, $orig_obj) = @_;

    my $p = MT->component('AssetTagging');

    my $blog_id = $obj->blog_id;
    my $param = $app->param;

    # プラグインの設定を取得する
    my $scope = (!$blog_id) ? 'system' : 'blog:' . $blog_id;
    my $cfg_basename_tag = $p->get_config_value('basename_tag', $scope);
    my @basename_tag = split(/\n/, $cfg_basename_tag);

    # カスタムフィールドに関連付けられている画像のIDを取得する
    foreach my $value (@basename_tag) {
        $value =~ /([^:]*):([^:]*)/;
        my ($field, $tag_name) = ('customfield_' . $1, $2);

        my $cf_value = $param->{param}->{$field}->[0];

        my $asset_id = 0;
        if ($cf_value =~ /mt:asset-id="(\d+)"/) {
            $asset_id = $1;
        } else {
            next;
        }

        # タグをロードする
        my $tag = MT::Tag->load({name => $tag_name});
        unless (defined $tag) {
            # タグがない場合は新規作成
            $tag = MT::Tag->new;
            $tag->name($tag_name);
            $tag->is_private(1) if ($tag_name =~ /^@/);
            $tag->save or die 'Failed to save the asset.';
        }
        my $tag_id = $tag->id;

        # オブジェクトとタグを関連づける
        my $obj_tag = MT::ObjectTag->new;
        $obj_tag->set_values({
            blog_id => $blog_id,
            object_datasource => 'asset',
            object_id => $asset_id,
            tag_id => $tag_id,
        });
        $obj_tag->save or die 'Failed to tag assets.';
    }
    return 1;
}

1;