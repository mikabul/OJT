	let str = '';

	// 프로젝트 인원 등록 닫기 버튼
	function closeAddPMPop(){
		let addPMPop = document.getElementById('addPMPop');
		addPMPop.classList.add('none');
	}
	
	// 프로젝트 인원 조회 버튼
	function clickSearchPM(){
		let searchMem_nm = document.getElementById("searchMem_nm");
		str = searchMem_nm.value;
		
		getPMList();
	}
	
	// 인원 검색(fetch)
	function getPMList(){
		
		let mem_seq = document.querySelectorAll(".mem_seq");
		let mem_seqList = [];
		
		mem_seq.forEach(seq => {
			mem_seqList.push(seq.value);
		})
		
		fetch('/OJT/projectFetch/getNotAddProjectMember',{
			method : 'POST',
			headers : {
				'Content-Type' : 'application/json'
			},
			body: JSON.stringify({
				str : str,
				mem_seqList : mem_seqList
			})
		})
		.then(response => {
			if(response.ok){
				return response.json();
			}
			throw new Error("통신 에러");
		})
		.then(memberList => {
			
			let addPMListBodyHtml = '';
			
			if(memberList != null){
				
				const prj_st_dt = document.getElementById("prj_st_dt");
				const st_value = prj_st_dt.value;
				const prj_ed_dt = document.getElementById("prj_ed_dt");
				const ed_value = prj_ed_dt.value;
				
				let index = 0;
				
				memberList.forEach(member => {
					addPMListBodyHtml += '<tr>'
									+	'<td>'
									+	'<input type="checkbox" class="addPMListIndex" value="' + index + '"/>'
									+	'</td>'
									+	'<td>' + member.mem_seq + '</td>'
									+	'<td>' + member.mem_nm + '</td>'
									+	'<td>' + member.dept + '</td>'
									+	'<td>' + member.position + '</td>'
									+	'<td><input type="date" min="' + st_value + '" max="' + ed_value + '" value="' + st_value + '"/></td>'
									+	'<td><input type="date" min="' + st_value + '" max="' + ed_value + '" value="' + ed_value + '"/></td>'
									+	'<td><select class="role_select"></select></td>'
									+	'</tr>';
					index = index + 1;
				})
			} else {
				addPMListBodyHtml += '<tr><td colspan="8">조회 결과가 없습니다.</td></tr>';
			}
			
			$("#addPMListBody").html(addPMListBodyHtml);
			roleOptions();
		})
	}
	
	// 추가 버튼
	function addPM(){
		let table = document.getElementById("addPMListBody");
		let rows = table.rows;
		let indexList = document.querySelectorAll(".addPMListIndex");
		let index = [];
		
		let mem_seq = [];
		let mem_nm = [];
		let dept = [];
		let position = [];
		let st_dt = [];
		let ed_dt = [];
		let role = [];
		
		indexList.forEach(i => {
			if(i.checked == true){
				index.push(i.value);
			}
		})
		
		if(index.length == 0){
			alert('추가할 인원을 선택해주세요.');
			return false;
		}
		
		index.forEach(i => {
			let row = rows[i];
			mem_seq.push(row.cells[1].innerHTML);
			mem_nm.push(row.cells[2].innerHTML);
			dept.push(row.cells[3].innerHTML);
			position.push(row.cells[4].innerHTML);
			st_dt.push(row.cells[5].querySelector("input").value);
			ed_dt.push(row.cells[6].querySelector("input").value);
			role.push(row.cells[7].querySelector("select").value);
		})
		
		let addPMBody = document.getElementById("addPMBody");
		let row_length = addPMBody.rows.length;
		
		let addPMBodyHtml = $("#addPMBody").html();
		
		for(let i = 0; i < mem_seq.length; i++){
			
			addPMBodyHtml += '<tr>'
							+	'<td class="text-center">'
							+	'<input class type="checkbox" value="' + (row_length + i) + '">'
							+	'</td>'
							+	'<td>'
							+	'<input id="projectMemberList' + (row_length + i) + '.mem_seq" name="projectMemberList[' + (row_length + i) + '.mem_seq" '
							+	'class="w-100 read-input text-center mem_seq" readonly="readonly" type="text" value="' + mem_seq[i] + '">'
							+	'</td>'
							+	'</td>'
							+	'<td>'
							+	'<input id="projectMemberList' + (row_length + i) + '.mem_nm" name="projectMemberList[' + (row_length + i) + '.mem_nm" '
							+	'class="w-100 read-input text-center" readonly="readonly" type="text" value="' + mem_nm[i] + '">'
							+	'</td>'
							+	'<td>'
							+	'<input id="projectMemberList' + (row_length + i) + '.dept" name="projectMemberList[' + (row_length + i) + '.dept" '
							+	'class="w-100 read-input text-center" readonly="readonly" type="text" value="' + dept[i] + '">'
							+	'</td>'
							+	'<td>'
							+	'<input id="projectMemberList' + (row_length + i) + '.position" name="projectMemberList[' + (row_length + i) + '.position" '
							+	'class="w-100 read-input text-center" readonly="readonly" type="text" value="' + position[i] + '">'
							+	'</td>'
							+	'<td>'
							+	'<input id="projectMemberList' + (row_length + i) + '.st_dt" name="projectMemberList[' + (row_length + i) + '.st_dt" '
							+	'type="date" class="w-100 st_dt" index="' + (row_length + i) + '" value="' + st_dt[i] + '">'
							+	'</td>'
							+	'<td>'
							+	'<input id="projectMemberList' + (row_length + i) + '.ed_dt" name="projectMemberList[' + (row_length + i) + '.ed_dt" '
							+	'type="date" class="w-100 ed_dt" index="' + (row_length + i) + '" value="' + ed_dt[i] + '">'
							+	'</td>'
							+	'<td>'
							+	'<select id="projectMemberList' + (row_length + i) + '.role" name="projectMemberList[' + (row_length + i) + '.role" '
							+	'class="w-100 role_select"></select>'
							+	'</td>'
							+	'</tr>';
			
		}//for_END
		
		$("#addPMBody").html(addPMBodyHtml);
		roleOptions();
		closeAddPMPop();
	}
	
	function selectOption(role, row_length){
		roleOptions();
		
		//'projectMemberList' + (row_length + i) +'\.role'
		for (let i = 0; i < role.length; i++) {
			let selectElement = document.getElementById('projectMemberList' + (row_length + i) + '.role');
			let optionToSelect = selectElement.querySelector('option[value="3"]');
			if (optionToSelect) {
				console.log(optionToSelect);
				optionToSelect.selected = true;
			} else {
				console.error('Value가 3인 <option>을 찾을 수 없습니다.');
			}
		}
	}
