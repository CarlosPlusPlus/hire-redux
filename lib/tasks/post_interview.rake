namespace :cron do
  desc "Updates Interviewing state to Pending after interview takes place."
  task :post_interview => :environment do

	relationships_with_interviews = Relationship.all.select {|rel| rel.aasm_state == "interviewing"}
	
	relationships_with_interviews.each do |rel|
		i = Interview.find_by_user_id_and_job_id(rel.user_id, rel.job_id)
		
		if i
			i_date = i.merge_datetime_object
			if i_date < Time.now
				rel.post_interview
				Record.write_record(rel) if rel.save
			end
		end
		
	end

	# If original interview (in past) is rescheduled for future date, this changes its state from pending to interviewing

	relationships_with_interviews = Relationship.all.select {|rel| rel.aasm_state == "pending"}
	
	relationships_with_interviews.each do |rel|
		i = Interview.find_by_user_id_and_job_id(rel.user_id, rel.job_id)
		
		if i
			i_date = i.merge_datetime_object
			if i_date > Time.now
				rel.aasm_state = "interviewing"
				Record.write_record(rel) if rel.save
			end
		end
	end

	end
end