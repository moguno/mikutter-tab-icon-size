# -*- coding: utf-8 -*-

Plugin.create :tab_icon_size do
  i_tabs = []

  UserConfig[:tab_icon_size] ||= 24

  # replace tab_update_icon()
  Plugin[:gtk].instance_eval {
    def tab_update_icon_ex(i_tab)
      type_strict i_tab => Plugin::GUI::TabLike

      tab = widgetof(i_tab)
      if tab
        tab.remove(tab.child) if tab.child
        if i_tab.icon.is_a?(String)
          tab.add(::Gtk::WebIcon.new(i_tab.icon, UserConfig[:tab_icon_size], UserConfig[:tab_icon_size]).show)
        else
          tab.add(::Gtk::Label.new(i_tab.name).show) end end
      self 
    end

    alias :tab_update_icon2 :tab_update_icon
    alias :tab_update_icon :tab_update_icon_ex
  }

  on_boot do
    UserConfig.connect(:tab_icon_size) { |key, val, before, id|
      i_tabs.each { |i_tab|
        icon = i_tab.icon
        i_tab.set_icon nil
        i_tab.set_icon icon
      }
    }
  end

  settings "タブのアイコンサイズ" do
      adjustment("アイコンサイズ", :tab_icon_size, 1, 100)
  end

  on_tab_created do |i_tab|
    i_tabs << i_tab
    i_tab.set_icon i_tab.icon
  end
end
