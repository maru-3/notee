module Notee
	class Authority
		include ActiveModel::Model

		class AuthorityError < StandardError; end
		class << self

			TARGET_ARR = ['Post', 'Category', 'Image', 'User']

			def check(crud, new_model_obj)

				check_deleted
				role = get_role

				case role
					when 'writer' then
						writer(crud, new_model_obj)
					when 'editor' then
						editor(crud, new_model_obj)
					when 'manager' then
						manager(crud, new_model_obj)
					when 'root' then
						root_user(crud, new_model_obj)
					else
				end
			end


			def get_role
				token = Token.find_by(access_token: Thread.current[:request].session[:access_token])
				return token.user.role
			end

			def get_user_id
				token = Token.find_by(access_token: Thread.current[:request].session[:access_token])
				return token.user.id
			end

			private

			# /////////////////////////////////
			# WRITER
			# /////////////////////////////////

			# you can
			# create: 	posts, categories, images
			# update:		my posts, categories, images, my user without role
			# delete:		my posts

			# you cannot
			# create: 	users
			# update: 	other posts, other users, my user role
			# delete:		other posts, categories, images, users

			def writer(crud, new_model_obj)
				case crud
					when 'create' then
						writer_create(new_model_obj)
					when 'update' then
						writer_update(new_model_obj)
					when 'destroy' then
						writer_destroy(new_model_obj)
					else
				end
			end

			def writer_create(new_model_obj)
				case new_model_obj.class.name
					when /Post/ then
						# success
						Rails.logger.debug("Writer create a post")
					when /Category/ then
						# success
						Rails.logger.debug("Writer create a category")
					when /Image/ then
						# success
						Rails.logger.debug("Writer create a image")
					when /User/ then
						# error
						raise AuthorityError, 'Writer can not create User'
					else
				end
			end

			def writer_update(new_model_obj)
				case new_model_obj.class.name
					when /Post/ then
						# error
						raise AuthorityError, 'Writer can update only my Post' unless get_user_id == new_model_obj.user_id

						# success
						Rails.logger.debug("Writer update my post")
					when /Category/ then
						# success
						Rails.logger.debug("Writer update a category")
					when /Image/ then
						# success
						Rails.logger.debug("Writer update a image")
					when /User/ then
						# error
						raise AuthorityError, 'Writer can update only my Post' unless get_user_id == new_model_obj.id

						# success
						Rails.logger.debug("Writer update my user")
					else

				end
			end

			def writer_destroy(new_model_obj)
				case new_model_obj.class.name
					when /Post/ then
						# error
						raise AuthorityError, 'Writer can destroy only my Post' unless get_user_id == new_model_obj.user_id

						# success
						Rails.logger.debug("Writer destroy my post")
					when /Category/ then
						# error
						raise AuthorityError, 'Writer can not destroy Category'
					when /Image/ then
						# error
						raise AuthorityError, 'Writer can not destroy Image'
					when /User/ then
						# error
						raise AuthorityError, 'Writer can not destroy User'
					else

				end
			end

			# /////////////////////////////////
			# EDITOR - Restriction
			# /////////////////////////////////

			# you can
			# create: 	posts, categories, images
			# update:		posts, categories, images, my user without role
			# delete: 	posts, categories, images

			# you cannot
			# - create: 	users
			# - update: 	other users, my user role
			# - delete: 	users

			def editor(crud, new_model_obj)
				case crud
					when 'create' then
						editor_create(new_model_obj)
					when 'update' then
						editor_update(new_model_obj)
					when 'destroy' then
						editor_destroy(new_model_obj)
					else

				end
			end

			def editor_create(new_model_obj)
				case new_model_obj.class.name
					when /Post/ then
						# success
						Rails.logger.debug("Editor create a post")
					when /Category/ then
						# success
						Rails.logger.debug("Editor create a category")
					when /Image/ then
						# success
						Rails.logger.debug("Editor create a image")
					when /User/ then
						# error
						raise AuthorityError, 'Editor can not destroy User'
					else

				end
			end

			def editor_update(new_model_obj)
				case new_model_obj.class.name
					when /Post/ then
						# success
						Rails.logger.debug("Editor update a post")
					when /Category/ then
						# success
						Rails.logger.debug("Editor update a category")
					when /Image/ then
						# success
						Rails.logger.debug("Editor update a image")
					when /User/ then
						# error
						raise AuthorityError, 'Editor can update only my Post' unless get_user_id == new_model_obj.id

						# success
						Rails.logger.debug("Editor update a user")
					else

				end
			end

			def editor_destroy(new_model_obj)
				case new_model_obj.class.name
					when /Post/ then
						# success
						Rails.logger.debug("Editor destroy a post")
					when /Category/ then
						# success
						Rails.logger.debug("Editor destroy a category")
					when /Image/ then
						# success
						Rails.logger.debug("Editor destroy a image")
					when /User/ then
						# error
						raise AuthorityError, 'Editor can not destroy User'
					else

				end
			end

			# /////////////////////////////////
			# MANAGER - Restriction
			# /////////////////////////////////

			# you can
			# create: 	posts, categories, images, users
			# update:		posts, categories, images, users
			# delete: 	posts, categories, images, users

			# you cannot
			# - create: 	none
			# - update: 	none
			# - delete: 	none

			def manager(crud, new_model_obj)
				case crud
					when 'create' then
						manager_create(new_model_obj)
					when 'update' then
						manager_update(new_model_obj)
					when 'destroy' then
						manager_destroy(new_model_obj)
					else

				end
			end

			def manager_create(new_model_obj)
				case new_model_obj.class.name
					when /Post/ then
						# success
						Rails.logger.debug("Manager create a post")
					when /Category/ then
						# success
						Rails.logger.debug("Manager create a category")
					when /Image/ then
						# success
						Rails.logger.debug("Manager create a image")
					when /User/ then
						# success
						Rails.logger.debug("Manager create a user")
					else

				end
			end

			def manager_update(new_model_obj)
				case new_model_obj.class.name
					when /Post/ then
						# success
						Rails.logger.debug("Manager update a post")
					when /Category/ then
						# success
						Rails.logger.debug("Manager update a category")
					when /Image/ then
						# success
						Rails.logger.debug("Manager update a image")
					when /User/ then
						# success
						Rails.logger.debug("Manager update a user")
					else

				end
			end

			def manager_destroy(new_model_obj)
				case new_model_obj.class.name
					when /Post/ then
						# success
						Rails.logger.debug("Manager destroy a post")
					when /Category/ then
						# success
						Rails.logger.debug("Manager destroy a category")
					when /Image/ then
						# success
						Rails.logger.debug("Manager destroy a image")
					when /User/ then
						# success
						Rails.logger.debug("Manager destroy a user")
					else

				end
			end

			# /////////////////////////////////
			# ROOT
			# /////////////////////////////////

			# you can
			# create: 	users
			# update:		none
			# delete: 	none

			# you cannot
			# - create: 	posts, categories, images
			# - update: 	posts, categories, images, users
			# - delete: 	posts, categories, images, users

			def root_user(crud, new_model_obj)
				case crud
					when 'create' then
						root_create(new_model_obj)
					when 'update' then
						root_update(new_model_obj)
					else
						# error
						raise AuthorityError, 'Root user only create User, and update own profile'
				end
			end

			def root_create(new_model_obj)
				case new_model_obj.class.name
					when /User/ then
						# success
						Rails.logger.debug("Root user create a user")
					else
						# error
						raise AuthorityError, 'Root user only create User'
				end
			end

			def root_update(new_model_obj)
				case new_model_obj.class.name
					when /User/ then
						raise AuthorityError, 'Root user only update own profile' unless new_model_obj.id == 0
						# success
						Rails.logger.debug("Root user update own profile")
					else
						# error
						raise AuthorityError, 'Root user only update own profile'
				end
			end

			# /////////////////////////////////
			# DELETED
			# /////////////////////////////////

			# you can
			# create: 	none
			# update:		none
			# delete: 	none

			# you cannot
			# - create: 	all
			# - update: 	all
			# - delete: 	all

			def check_deleted
				token = Token.find_by(access_token: Thread.current[:request].session[:access_token])
				if token.user.is_deleted
					# error
					raise AuthorityError, 'This User is Deleted..'
				end
			end

		end
	end
end

