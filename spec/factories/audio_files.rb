module Pageflow
  FactoryGirl.define do
    factory :audio_file, :class => AudioFile do
      entry
      uploader { create(:user) }

      attachment_on_s3 File.open(Engine.root.join('spec', 'fixtures', 'et.ogg'))

      ignore do
        used_in nil
      end

      before(:create) do |file, evaluator|
        file.entry = evaluator.used_in.entry if evaluator.used_in
      end

      after(:create) do |file, evaluator|
        create(:file_usage, :file => file, :revision => evaluator.used_in) if evaluator.used_in
      end

      trait :on_filesystem do
        attachment_on_filesystem File.open(Engine.root.join('spec', 'fixtures', 'et.ogg'))
        attachment_on_s3 nil
        state 'not_uploaded_to_s3'
      end

      trait :upload_to_s3_failed do
        attachment_on_filesystem File.open(Engine.root.join('spec', 'fixtures', 'et.ogg'))
        attachment_on_s3 nil
        state 'upload_to_s3_failed'
      end

      trait :encoding_failed do
        state 'encoding_failed'
      end

      trait :encoded do
        state 'encoded'
      end
    end
  end
end
