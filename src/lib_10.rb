#============================================================================== 
# 本脚本来自[url]www.66RPG.com[/url]，使用和转载请保留此信息 
#============================================================================== 
#============================================================================== 
# ■ Harts_Window_ItemTitle 
#------------------------------------------------------------------------------ 
# 　アイテム画面で、タイトルを表示するウィンドウ。 
#============================================================================== 
class Harts_Window_ItemTitle < Window_Base 
  #-------------------------------------------------------------------------- 
  # ● オブジェクト初期化 
  #-------------------------------------------------------------------------- 
  def initialize 
    super(0, 0, 160, 64) 
    self.contents = Bitmap.new(width - 32, height - 32) 
    self.contents.clear 
    self.contents.font.color = normal_color 
    self.contents.draw_text(4, 0, 120, 32, $data_system.words.item, 1) 
  end 
end 
#============================================================================== 
# ■ Harts_Window_ItemCommand 
#------------------------------------------------------------------------------ 
# 　アイテムの種別選択を行うウィンドウです。 
#============================================================================== 
class Harts_Window_ItemCommand < Window_Selectable 
  #-------------------------------------------------------------------------- 
  # ● オブジェクト初期化 
  #-------------------------------------------------------------------------- 
  def initialize 
    super(0, 64, 160, 288) 
    self.contents = Bitmap.new(width - 32, height - 32) 
    @item_max = 8 
    @commands = ["一般用", "战斗用", $data_system.words.weapon, $data_system.words.armor1, $data_system.words.armor2, $data_system.words.armor3, $data_system.words.armor4, "特殊道具"] 
    refresh 
    self.index = 0 
  end 
  #-------------------------------------------------------------------------- 
  # ● リフレッシュ 
  #-------------------------------------------------------------------------- 
  def refresh 
    self.contents.clear 
    for i in 0...@item_max 
    draw_item(i, normal_color) 
    end 
  end 
  #-------------------------------------------------------------------------- 
  # ● 項目の描画 
  # index : 項目番号 
  # color : 文字色 
  #-------------------------------------------------------------------------- 
  def draw_item(index, color) 
    self.contents.font.color = color 
    y = index * 32 
    self.contents.draw_text(4, y, 128, 32, @commands[index]) 
  end 
  #-------------------------------------------------------------------------- 
  # ● ヘルプテキスト更新 
  #-------------------------------------------------------------------------- 
  def update_help 
    case self.index 
    when 0 
      @text = @commands[0] 
    when 1 
      @text = @commands[1] 
    when 2 
      @text = @commands[2] 
    when 3 
      @text = @commands[3] 
    when 4 
      @text = @commands[4] 
    when 5 
      @text = @commands[5] 
    when 6 
      @text = @commands[6] 
    when 7 
      @text = @commands[7] 
    end 
    @help_window.set_text(@text) 
  end 
end 
#============================================================================== 
# ■ Window_Item 
#------------------------------------------------------------------------------ 
# 　アイテム画面で、所持アイテムの一覧を表示するウィンドウです。 
#============================================================================== 
class Harts_Window_ItemList < Window_Selectable 
  #-------------------------------------------------------------------------- 
  # ● オブジェクト初期化 
  #-------------------------------------------------------------------------- 
  def initialize 
    super(160, 0, 480, 416) 
    refresh 
    self.index = 0 
  end 
  #-------------------------------------------------------------------------- 
  # ● アイテムの取得 
  #-------------------------------------------------------------------------- 
  def item 
    return @data[self.index] 
  end 
  #-------------------------------------------------------------------------- 
  # ● リフレッシュ 
  #-------------------------------------------------------------------------- 
  def refresh 
    if self.contents != nil 
      self.contents.dispose 
      self.contents = nil 
    end 
    @data = [] 
  end 
  #-------------------------------------------------------------------------- 
  # ● アイテム一覧設定 
  # command : 選択中のコマンド 
  #-------------------------------------------------------------------------- 
  def set_item(command) 
    refresh 
    case command 
    when 0 
      for i in 1...$data_items.size 
        if ($data_items[i].occasion == 0 or $data_items[i].occasion == 2) and $game_party.item_number(i) > 0 
          @data.push($data_items[i]) 
        end 
      end 
    when 1 
      for i in 1...$data_items.size 
        if ($data_items[i].occasion == 1 and $game_party.item_number(i) > 0) 
          @data.push($data_items[i]) 
        end 
      end 
    when 2 
      for i in 1...$data_weapons.size 
        if $game_party.weapon_number(i) > 0 
          @data.push($data_weapons[i]) 
        end 
      end 
    when 3 
      for i in 1...$data_armors.size 
        if $data_armors[i].kind == 0 and $game_party.armor_number(i) > 0 
          @data.push($data_armors[i]) 
        end 
      end 
    when 4 
      for i in 1...$data_armors.size 
        if $data_armors[i].kind == 1 and $game_party.armor_number(i) > 0 
          @data.push($data_armors[i]) 
        end 
      end 
    when 5 
      for i in 1...$data_armors.size 
        if $data_armors[i].kind == 2 and $game_party.armor_number(i) > 0 
          @data.push($data_armors[i]) 
        end 
      end 
    when 6 
      for i in 1...$data_armors.size 
        if $data_armors[i].kind == 3 and $game_party.armor_number(i) > 0 
          @data.push($data_armors[i]) 
        end 
      end 
    when 7 
      for i in 1...$data_items.size 
        if $data_items[i].occasion == 3 and $game_party.item_number(i) > 0 
          @data.push($data_items[i]) 
        end 
      end 
    end 
    # 項目数が 0 でなければビットマップを作成し、全項目を描画 
    @item_max = @data.size 
    if @item_max > 0 
      self.contents = Bitmap.new(width - 32, row_max * 32) 
      self.contents.clear 
      for i in 0...@item_max 
        draw_item(i) 
      end 
    end 
  end 
  #-------------------------------------------------------------------------- 
  # ● 種類別アイテム数の取得 
  #-------------------------------------------------------------------------- 
  def item_number 
    return @item_max 
  end 
  #-------------------------------------------------------------------------- 
  # ● 項目の描画 
  # index : 項目番号 
  #-------------------------------------------------------------------------- 
  def draw_item(index) 
    item = @data[index] 
    case item 
    when RPG::Item 
      number = $game_party.item_number(item.id) 
    when RPG::Weapon 
      number = $game_party.weapon_number(item.id) 
    when RPG::Armor 
      number = $game_party.armor_number(item.id) 
    end 
    if item.is_a?(RPG::Item) and 
      $game_party.item_can_use?(item.id) 
      self.contents.font.color = normal_color 
    else 
      self.contents.font.color = disabled_color 
    end 
    x = 4 
    y = index * 32 
    bitmap = RPG::Cache.icon(item.icon_name) 
    opacity = self.contents.font.color == normal_color ? 255 : 128 
    self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24), opacity) 
    self.contents.draw_text(x + 28, y, 212, 32, item.name, 0) 
    self.contents.draw_text(x + 400, y, 16, 32, ":", 1) 
    self.contents.draw_text(x + 416, y, 24, 32, number.to_s, 2) 
  end 
  #-------------------------------------------------------------------------- 
  # ● ヘルプテキスト更新 
  #-------------------------------------------------------------------------- 
  def update_help 
    @help_window.set_text(self.item == nil ? "" : self.item.description) 
  end 
end 
#============================================================================== 
# ■ Harts_Scene_Item 
#------------------------------------------------------------------------------ 
# 　アイテム画面の処理を行うクラスです。再定義 
#============================================================================== 
class Scene_Item 
  #-------------------------------------------------------------------------- 
  # ● メイン処理 
  #-------------------------------------------------------------------------- 
  def main 
    # タイトルウィンドウを作成 
    @itemtitle_window = Harts_Window_ItemTitle.new 
    #コマンドウィンドウを作成 
    @itemcommand_window = Harts_Window_ItemCommand.new 
    @command_index = @itemcommand_window.index 
    #アイテムウィンドウを作成 
    @itemlist_window = Harts_Window_ItemList.new 
    @itemlist_window.active = false 
    #ヘルプウィンドウを作成 
    @help_window = Window_Help.new 
    @help_window.x = 0 
    @help_window.y = 416 
    # ヘルプウィンドウを関連付け 
    @itemcommand_window.help_window = @help_window 
    @itemlist_window.help_window = @help_window 
    # ターゲットウィンドウを作成 (不可視?非アクティブに設定) 
    @target_window = Window_Target.new 
    @target_window.visible = false 
    @target_window.active = false 
    # アイテムウィンドウ内容表示 
    @itemlist_window.set_item(@command_index) 
    # トランジション実行 
    Graphics.transition 
    # メインループ 
    loop do 
      # ゲーム画面を更新 
      Graphics.update 
      # 入力情報を更新 
      Input.update 
      # フレーム更新 
      update 
      # 画面が切り替わったらループを中断 
      if $scene != self 
        break 
      end 
    end 
    # トランジション準備 
    Graphics.freeze 
    # ウィンドウを解放 
    @itemtitle_window.dispose 
    @itemcommand_window.dispose 
    @itemlist_window.dispose 
    @help_window.dispose 
    @target_window.dispose 
  end 
  #-------------------------------------------------------------------------- 
  # ● フレーム更新 
  #-------------------------------------------------------------------------- 
  def update 
    # ウィンドウを更新 
    @itemtitle_window.update 
    @itemcommand_window.update 
    @itemlist_window.update 
    @help_window.update 
    @target_window.update 
    if @command_index != @itemcommand_window.index 
      @command_index = @itemcommand_window.index 
      @itemlist_window.set_item(@command_index) 
    end 
    # コマンドウィンドウがアクティブの場合: update_itemcommand を呼ぶ 
    if @itemcommand_window.active 
      update_itemcommand 
      return 
    end 
    # アイテムウィンドウがアクティブの場合: update_itemlist を呼ぶ 
    if @itemlist_window.active 
      update_itemlist 
      return 
    end 
    # ターゲットウィンドウがアクティブの場合: update_target を呼ぶ 
    if @target_window.active 
      update_target 
      return 
    end 
  end 
  #-------------------------------------------------------------------------- 
  # ● フレーム更新 (コマンドウィンドウがアクティブの場合) 
  #-------------------------------------------------------------------------- 
  def update_itemcommand 
  # B ボタンが押された場合 
  if Input.trigger?(Input::B) 
  # キャンセル SE を演奏 
  $game_system.se_play($data_system.cancel_se) 
  # メニュー画面に切り替え 
  $scene = Scene_Menu.new(0) 
  return 
  end 
  # C ボタンが押された場合 
  if Input.trigger?(Input::C) 
  # 選択中のコマンドのアイテムがない場合 
  if @itemlist_window.item_number == 0 
  # ブザー SE を演奏 
  $game_system.se_play($data_system.buzzer_se) 
  return 
  end 
  # 決定 SE を演奏 
  $game_system.se_play($data_system.decision_se) 
  # アイテムウィンドウをアクティブにする 
  @itemcommand_window.active = false 
  @itemlist_window.active = true 
  @itemlist_window.index = 0 
  return 
  end 
  end 
  #-------------------------------------------------------------------------- 
  # ● フレーム更新 (アイテムウィンドウがアクティブの場合) 
  #-------------------------------------------------------------------------- 
  def update_itemlist 
    # B ボタンが押された場合 
    if Input.trigger?(Input::B) 
      # キャンセル SE を演奏 
      $game_system.se_play($data_system.cancel_se) 
      # アイテムウィンドウをアクティブにする 
      @itemcommand_window.active = true 
      @itemlist_window.active = false 
      @itemlist_window.index = 0 
      @itemcommand_window.index = @command_index 
      return 
    end 
    # C ボタンが押された場合 
    if Input.trigger?(Input::C) 
      # アイテムウィンドウで現在選択されているデータを取得 
      @item = @itemlist_window.item 
      # 使用アイテムではない場合 
      unless @item.is_a?(RPG::Item) 
        # ブザー SE を演奏 
        $game_system.se_play($data_system.buzzer_se) 
        return 
      end 
      # 使用できない場合 
      unless $game_party.item_can_use?(@item.id) 
        # ブザー SE を演奏 
        $game_system.se_play($data_system.buzzer_se) 
        return 
      end 
      # 決定 SE を演奏 
      $game_system.se_play($data_system.decision_se) 
      # 効果範囲が味方の場合 
      if @item.scope >= 3 
        # ターゲットウィンドウをアクティブ化 
        @itemlist_window.active = false 
        @target_window.x = 304 
        @target_window.visible = true 
        @target_window.active = true 
        # 効果範囲 (単体/全体) に応じてカーソル位置を設定 
        if @item.scope == 4 || @item.scope == 6 
          @target_window.index = -1 
        else 
          @target_window.index = 0 
        end 
        # 効果範囲が味方以外の場合 
      else 
        # コモンイベント ID が有効の場合 
        if @item.common_event_id > 0 
          # コモンイベント呼び出し予約 
          $game_temp.common_event_id = @item.common_event_id 
          # アイテムの使用時 SE を演奏 
          $game_system.se_play(@item.menu_se) 
          # 消耗品の場合 
            if @item.consumable 
              # 使用したアイテムを 1 減らす 
              $game_party.lose_item(@item.id, 1) 
              # アイテムウィンドウの項目を再描画 
              @itemlist_window.draw_item(@itemlist_window.index) 
            end 
          # マップ画面に切り替え 
          $scene = Scene_Map.new 
          return 
        end 
      end 
      return 
    end 
  end 
  #-------------------------------------------------------------------------- 
  # ● フレーム更新 (ターゲットウィンドウがアクティブの場合) 
  #-------------------------------------------------------------------------- 
  def update_target 
    # B ボタンが押された場合 
    if Input.trigger?(Input::B) 
      # キャンセル SE を演奏 
      $game_system.se_play($data_system.cancel_se) 
      # アイテム切れなどで使用できなくなった場合 
      unless $game_party.item_can_use?(@item.id) 
        # アイテムウィンドウの内容を再作成 
        @itemlist_window.refresh 
      end 
      # ターゲットウィンドウを消去 
      @itemlist_window.active = true 
      @target_window.visible = false 
      @target_window.active = false 
      @itemlist_window.set_item(@command_index) 
      return 
    end 
    # C ボタンが押された場合 
    if Input.trigger?(Input::C) 
      # アイテムを使い切った場合 
      if $game_party.item_number(@item.id) == 0 
        # ブザー SE を演奏 
        $game_system.se_play($data_system.buzzer_se) 
        return 
      end 
      # ターゲットが全体の場合 
      if @target_window.index == -1 
        # パーティ全体にアイテムの使用効果を適用 
        used = false 
        for i in $game_party.actors 
          used |= i.item_effect(@item) 
        end 
      end 
      # ターゲットが単体の場合 
      if @target_window.index >= 0 
        # ターゲットのアクターにアイテムの使用効果を適用 
        target = $game_party.actors[@target_window.index] 
        used = target.item_effect(@item) 
      end 
      # アイテムを使った場合 
      if used 
        # アイテムの使用時 SE を演奏 
        $game_system.se_play(@item.menu_se) 
        # 消耗品の場合 
        if @item.consumable 
          # 使用したアイテムを 1 減らす 
          $game_party.lose_item(@item.id, 1) 
          # アイテムウィンドウの項目を再描画 
          @itemlist_window.draw_item(@itemlist_window.index) 
          @itemlist_window.set_item(@command_index) 
        end 
        # ターゲットウィンドウの内容を再作成 
        @target_window.refresh 
        # 全滅の場合 
        if $game_party.all_dead? 
          # ゲームオーバー画面に切り替え 
          $scene = Scene_Gameover.new 
          return 
        end 
        # コモンイベント ID が有効の場合 
        if @item.common_event_id > 0 
          # コモンイベント呼び出し予約 
          $game_temp.common_event_id = @item.common_event_id 
          # マップ画面に切り替え 
          $scene = Scene_Map.new 
          return 
        end 
      end 
      # アイテムを使わなかった場合 
      unless used 
        # ブザー SE を演奏 
        $game_system.se_play($data_system.buzzer_se) 
      end 
    return 
    end 
  end 
end 
#============================================================================== 
# 本脚本来自[url]www.66RPG.com[/url]，使用和转载请保留此信息 
#==============================================================================
