ActiveAdmin.register Post do
  permit_params :title, :body, :status

  index do
    selectable_column
    id_column
    column :title
    column :body
    column :status
    column :postable_type
    column :created_at
    actions
  end

  filter :status, {
    as: :select,
    collection: Post::STATUS_OPTIONS,
  }

  filter :created_at

  filter :user, {
    as: :select,
    collection: User.all,
    member_label: :email,
  }

  filter :postable_type

  form do |f|
    f.inputs do
      f.input :user, {
        as: :select,
        collection: User.all,
        member_label: :email,
        include_blank: true,
        allow_blank: false
      }

      f.input :postable, {
        collection: User.all,
        member_label: :email,
        include_blank: true,
        allow_blank: false
      }

      f.input :title
      f.input :body
      f.input :status, {
        as: :select,
        collection: Post::STATUS_OPTIONS,
        include_blank: false,
        allow_blank: false
      }
    end
    f.actions
  end

end
