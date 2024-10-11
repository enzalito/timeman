<template>
    <div>
      <table>      
        <thead>
          <tr>                       
            <th>Date d'entrée</th>
            <th>Date de sortie</th>
          </tr>
        </thead>             
        <tbody>  
          <tr v-for="(item, index) in tabData" :key="index">
            <td colspan="2">
              <div class="row-container">
                <span>{{ item.start }}</span>
                <span>{{ item.end }}</span>
              </div>
            </td>
          </tr>  
        </tbody>
        
      </table>
    </div>
</template>
<script lang="ts">

  import { defineComponent, onMounted, ref } from 'vue';
  import { useUserStore } from "@/stores/user";
  
  export default defineComponent({
    // eslint-disable-next-line vue/multi-word-component-names
    name: 'Chart1',
    
    setup() {
      
      const userStore = useUserStore();

        
      const tabData = ref([
          {start: "2024-06-10 08-00-00", end: "2024-06-10 08-00-00" },
                  
      ]);

      const formatDate = (dateString: string) => {
        const date = new Date(dateString);
        return date.toLocaleDateString('fr-FR'); 
      };

      const formatTime = (dateString: string) => {
        const date = new Date(dateString);
        return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
      };

      const fetchData_workingtime = async (userId: number) => {
        try {
              
          const url = `http://localhost:4000/api/workingtime/${userId}`;
          const response = await fetch(url); 

          if (!response.ok) {
            throw new Error('Network response was not ok');
          }
          const data = await response.json();
            
          const formattedData = data.data.map((item: any) => {
            return {
              ...item,
              start: formatDate(item.start) + ' ' + formatTime(item.start),
              end: formatDate(item.end) + ' ' + formatTime(item.end),
            };
          });

          tabData.value = formattedData;

        } catch (error) {
          console.error('Erreur lors de la récupération des données dans tabData:', error);
        }
      };

      onMounted(()=> {  
        if (userStore.user) {
          fetchData_workingtime(userStore.user.id);
        }
      });

      return {
          tabData,
      };
  },
});

</script>
  
<style>

  table {   
      overflow: hidden;      
      padding: 10px;
      background-color: rgb(0, 0, 255,0);
      border-collapse: separate;
      border-spacing: 10px;
  }
  
  td {
      text-align: left;
      border: 1px solid #adaaaa00;
      background-color: rgb(127, 255, 212,0);
  }
  
  span {
      margin: 0 30px;
      background-color: rgb(43, 226, 83,0);
  }

  .row-container {
      display: flex;
      justify-content: space-between;
      padding: 10px;
      border: 1px solid #adaaaa;
      border-radius: 10px;
      background-color: rgb(246, 255, 127,0);
      margin: 5px 0;
  }

</style>
