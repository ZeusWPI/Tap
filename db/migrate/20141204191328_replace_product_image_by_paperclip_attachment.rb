class ReplaceProductImageByPaperclipAttachment < ActiveRecord::Migration
  def change
    remove_column :products, :img_path, :string
    add_attachment :products, :avatar
  end
end
