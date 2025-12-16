<script lang="ts">
  import { onMount } from 'svelte';
  import * as api from '$lib/api';
  import { getMediaUrl } from '$lib/api';
  import type { Hero, Skill, Project, Experience, Certification, Contact, BlogPost, ExtraCurricularActivity } from '$lib/types';

  let hero: Hero | null = null;
  let skills: Skill[] = [];
  let projects: Project[] = [];
  let experience: Experience[] = [];
  let certifications: Certification[] = [];
  let contact: Contact | null = null;
  let blogPosts: BlogPost[] = [];
  let activities: ExtraCurricularActivity[] = [];
  let loading = true;
  let error = '';

  // Contact form state
  let formData = {
    name: '',
    email: '',
    subject: '',
    message: ''
  };
  let formSubmitting = false;
  let formSuccess = false;
  let formError = '';

  // Certification view state
  let showAllAchievements = false;
  let showAllCertificates = false;
  let showAllParticipation = false;
  let showAllCertifications = false;

  // Mobile menu state
  let mobileMenuOpen = false;

  function toggleMobileMenu() {
    mobileMenuOpen = !mobileMenuOpen;
  }

  function closeMobileMenu() {
    mobileMenuOpen = false;
  }

  // Skills category filter
  let selectedCategory = 'All';
  const categories = ['All', 'Language', 'Framework', 'Tool', 'Platform', 'Other'];
  let showAllSkills = false;

  onMount(async () => {
    try {
      // Fetch all data in parallel
      const [heroData, skillsData, projectsData, experienceData, certificationsData, contactData, blogData, activitiesData] = await Promise.all([
        api.getHero().catch(() => null),
        api.getSkills().catch(() => []),
        api.getProjects().catch(() => []),
        api.getExperience().catch(() => []),
        api.getCertifications().catch(() => []),
        api.getContact().catch(() => null),
        api.getBlogPosts().catch(() => []),
        api.getActivities().catch(() => [])
      ]);

      hero = heroData;
      skills = skillsData;
      projects = projectsData;
      experience = experienceData;
      certifications = certificationsData;
      contact = contactData;
      blogPosts = blogData;
      activities = activitiesData;
    } catch (err) {
      error = err instanceof Error ? err.message : 'Failed to load data';
      console.error('Error loading data:', err);
    } finally {
      loading = false;
    }
  });

  async function handleContactSubmit(e: Event) {
    e.preventDefault();
    formSubmitting = true;
    formSuccess = false;
    formError = '';

    try {
      await api.createMessage(formData);
      formSuccess = true;
      formData = { name: '', email: '', subject: '', message: '' };
      
      setTimeout(() => {
        formSuccess = false;
      }, 5000);
    } catch (err) {
      formError = err instanceof Error ? err.message : 'Failed to send message. Please try again.';
      console.error('Contact form error:', err);
    } finally {
      formSubmitting = false;
    }
  }
</script>

<div class="min-h-screen bg-black">
  {#if loading}
    <div class="flex items-center justify-center min-h-screen">
      <div class="text-xl text-primary-500">Loading...</div>
    </div>
  {:else if error}
    <div class="flex items-center justify-center min-h-screen">
      <div class="text-red-500">Error: {error}</div>
    </div>
  {:else}
    <!-- Navigation -->
    <nav class="fixed top-0 left-0 right-0 z-50 bg-black/90 backdrop-blur-lg border-b border-zinc-800/50">
      <div class="container mx-auto px-6 lg:px-8 py-4 flex items-center justify-between">
        <div class="flex items-center gap-2 group cursor-pointer">
          <svg class="w-8 h-8 text-primary-500 group-hover:scale-110 transition-transform" viewBox="0 0 24 24" fill="currentColor">
            <path d="M18.6 6.62c-1.44 0-2.8.56-3.77 1.53L12 10.66 10.48 12h.01L7.8 14.39c-.64.64-1.49.99-2.4.99-1.87 0-3.39-1.51-3.39-3.38S3.53 8.62 5.4 8.62c.91 0 1.76.35 2.44 1.03l1.13 1 1.51-1.34L9.22 8.2C8.2 7.18 6.84 6.62 5.4 6.62 2.42 6.62 0 9.04 0 12s2.42 5.38 5.4 5.38c1.44 0 2.8-.56 3.77-1.53l2.83-2.5.01.01L13.52 12h-.01l2.69-2.39c.64-.64 1.49-.99 2.4-.99 1.87 0 3.39 1.51 3.39 3.38s-1.52 3.38-3.39 3.38c-.9 0-1.76-.35-2.44-1.03l-1.14-1.01-1.51 1.34 1.27 1.12c1.02 1.01 2.37 1.57 3.82 1.57 2.98 0 5.4-2.41 5.4-5.38s-2.42-5.37-5.4-5.37z"/>
          </svg>
          <span class="text-white font-bold text-xl tracking-tight">M.H.MAHMUD</span>
        </div>
        <div class="hidden md:flex items-center gap-8 lg:gap-10">
          <a href="#home" class="text-sm font-medium text-gray-400 hover:text-primary-500 transition-colors relative group">
            Home
            <span class="absolute -bottom-1 left-0 w-0 h-0.5 bg-primary-500 group-hover:w-full transition-all duration-300"></span>
          </a>
          <a href="#skills" class="text-sm font-medium text-gray-400 hover:text-primary-500 transition-colors relative group">
            Skills
            <span class="absolute -bottom-1 left-0 w-0 h-0.5 bg-primary-500 group-hover:w-full transition-all duration-300"></span>
          </a>
          <a href="#projects" class="text-sm font-medium text-gray-400 hover:text-primary-500 transition-colors relative group">
            Projects
            <span class="absolute -bottom-1 left-0 w-0 h-0.5 bg-primary-500 group-hover:w-full transition-all duration-300"></span>
          </a>
          <a href="#experience" class="text-sm font-medium text-gray-400 hover:text-primary-500 transition-colors relative group">
            Experience
            <span class="absolute -bottom-1 left-0 w-0 h-0.5 bg-primary-500 group-hover:w-full transition-all duration-300"></span>
          </a>
          <a href="#certifications" class="text-sm font-medium text-gray-400 hover:text-primary-500 transition-colors relative group">
            Certifications
            <span class="absolute -bottom-1 left-0 w-0 h-0.5 bg-primary-500 group-hover:w-full transition-all duration-300"></span>
          </a>
          <a href="#activities" class="text-sm font-medium text-gray-400 hover:text-primary-500 transition-colors relative group">
            Activities
            <span class="absolute -bottom-1 left-0 w-0 h-0.5 bg-primary-500 group-hover:w-full transition-all duration-300"></span>
          </a>
          <a href="#contact" class="px-4 py-2 bg-primary-500 text-black text-sm font-semibold rounded-lg hover:bg-primary-400 transition-all hover:scale-105">
            Contact
          </a>
        </div>
        <!-- Mobile Menu Button -->
        <button on:click={toggleMobileMenu} class="md:hidden text-gray-400 hover:text-primary-500 transition-colors">
          {#if mobileMenuOpen}
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
            </svg>
          {:else}
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"/>
            </svg>
          {/if}
        </button>
      </div>
      
      <!-- Mobile Menu Dropdown -->
      {#if mobileMenuOpen}
        <div class="md:hidden border-t border-zinc-800/50 bg-black/95 backdrop-blur-lg">
          <div class="container mx-auto px-6 py-4 flex flex-col gap-3">
            <a href="#home" on:click={closeMobileMenu} class="text-base font-medium text-gray-400 hover:text-primary-500 transition-colors py-2">
              Home
            </a>
            <a href="#skills" on:click={closeMobileMenu} class="text-base font-medium text-gray-400 hover:text-primary-500 transition-colors py-2">
              Skills
            </a>
            <a href="#projects" on:click={closeMobileMenu} class="text-base font-medium text-gray-400 hover:text-primary-500 transition-colors py-2">
              Projects
            </a>
            <a href="#experience" on:click={closeMobileMenu} class="text-base font-medium text-gray-400 hover:text-primary-500 transition-colors py-2">
              Experience
            </a>
            <a href="#certifications" on:click={closeMobileMenu} class="text-base font-medium text-gray-400 hover:text-primary-500 transition-colors py-2">
              Certifications
            </a>
            <a href="#activities" on:click={closeMobileMenu} class="text-base font-medium text-gray-400 hover:text-primary-500 transition-colors py-2">
              Activities
            </a>
            <a href="#contact" on:click={closeMobileMenu} class="px-4 py-3 bg-primary-500 text-black text-base font-semibold rounded-lg hover:bg-primary-400 transition-all text-center mt-2">
              Contact
            </a>
          </div>
        </div>
      {/if}
    </nav>

    <!-- Hero Section -->
    {#if hero}
      <section id="home" class="min-h-screen flex items-center justify-center pt-24 pb-12 px-4 sm:px-6 lg:px-8">
        <div class="container mx-auto relative z-10">
          <div class="w-full">
            <div class="flex flex-col-reverse md:flex-row items-center justify-between gap-8 md:gap-12">
              <!-- Left Content -->
              <div class="flex-1">
                <!-- Status Badge -->
                <div class="mb-6">
                  <span class="inline-flex items-center gap-2 px-4 py-3 bg-zinc-950 border border-zinc-900 rounded-full text-sm text-gray-400">
                    <span class="w-2 h-2 bg-primary-500 rounded-full animate-pulse"></span>
                    Available for opportunities
                  </span>
                </div>

                <!-- Name -->
                <h1 class="text-4xl sm:text-5xl md:text-7xl lg:text-8xl font-bold mb-4 md:mb-6 text-white leading-tight">
                  {hero.name}
                </h1>

                <!-- Tagline -->
                <p class="text-xl sm:text-2xl md:text-3xl text-primary-500 mb-4 md:mb-6 font-medium">
                  {hero.tagline}
                </p>

                <!-- Description -->
                <p class="text-base sm:text-lg text-gray-400 mb-8 md:mb-10 max-w-2xl leading-relaxed">
                  {hero.description}
                </p>

                <!-- CTA Buttons -->
                <div class="flex flex-col sm:flex-row gap-3 sm:gap-4 items-stretch sm:items-start mb-8 md:mb-12 w-full sm:w-auto">
                  <a href="#projects" class="group inline-flex items-center justify-center gap-2 px-6 sm:px-8 py-3 sm:py-4 bg-primary-500 text-black text-sm sm:text-base font-semibold rounded-lg hover:bg-primary-400 transition-all hover:scale-105 hover:shadow-lg hover:shadow-primary-500/50">
                    <span>View Projects</span>
                    <svg class="w-5 h-5 group-hover:translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6"/>
                    </svg>
                  </a>
                  {#if hero.resume_url}
                    <a href={getMediaUrl(hero.resume_url)} target="_blank" rel="noopener" class="group inline-flex items-center justify-center gap-2 px-6 sm:px-8 py-3 sm:py-4 border-2 border-zinc-800 text-gray-300 text-sm sm:text-base font-semibold rounded-lg hover:bg-zinc-900 hover:border-primary-500 transition-all hover:scale-105">
                      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                      </svg>
                      <span>Download Resume</span>
                    </a>
                  {/if}
                </div>

                <!-- Social Links -->
                <div class="flex flex-wrap gap-4 sm:gap-6">
                  {#if hero.github_url}
                    <a href={hero.github_url} target="_blank" rel="noopener" class="text-gray-400 hover:text-primary-500 transition-colors text-2xl">
                      <svg class="w-8 h-8" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"/>
                      </svg>
                    </a>
                  {/if}
                  {#if hero.linkedin_url}
                    <a href={hero.linkedin_url} target="_blank" rel="noopener" class="text-gray-400 hover:text-primary-500 transition-colors text-2xl">
                      <svg class="w-8 h-8" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z"/>
                      </svg>
                    </a>
                  {/if}
                  {#if hero.twitter_url}
                    <a href={hero.twitter_url} target="_blank" rel="noopener" class="text-gray-400 hover:text-primary-500 transition-colors text-2xl">
                      <svg class="w-8 h-8" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z"/>
                      </svg>
                    </a>
                  {/if}
                  {#if hero.hackerrank_url}
                    <a href={hero.hackerrank_url} target="_blank" rel="noopener" class="text-gray-400 hover:text-primary-500 transition-colors text-2xl">
                      <svg class="w-8 h-8" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M 11.998047 0 C 10.494047 -1.4802974e-15 2.2966406 4.7119531 1.5566406 6.0019531 C 0.81164063 7.2959531 0.81359375 16.715 1.5585938 18 C 2.3035938 19.29 10.499047 24 11.998047 24 C 13.493047 24 21.691406 19.290953 22.441406 18.001953 C 23.193406 16.707953 23.191453 7.2850469 22.439453 5.9980469 C 21.686453 4.7080469 13.489047 0 11.998047 0 z M 11.998047 1 C 13.128047 1 21.005172 5.5249531 21.576172 6.5019531 C 22.145172 7.4759531 22.145172 16.519047 21.576172 17.498047 C 21.009172 18.475047 13.131047 22.998047 11.998047 22.998047 C 10.862047 22.998047 2.9878281 18.475047 2.4238281 17.498047 C 1.8608281 16.525047 1.8608281 7.4780469 2.4238281 6.4980469 C 2.9838281 5.5210469 10.858047 1 11.998047 1 z M 9.1875 4.0820312 C 8.6605 4.0820312 7.0353438 5.8205313 6.9023438 6.1445312 C 6.8253438 6.3305312 6.8667656 6.608 7.0097656 6.75 C 7.1267656 6.868 7.2595 6.9240312 7.6875 6.9570312 C 7.8135 12.261031 7.7452188 14.617547 7.6992188 16.185547 L 7.6875 16.585938 C 7.6795 16.829937 7.7476719 17.026875 7.8886719 17.171875 C 8.0266719 17.314875 8.2199375 17.386719 8.4609375 17.386719 L 9.8964844 17.390625 L 9.9042969 17.390625 C 10.149297 17.390625 10.342469 17.316875 10.480469 17.171875 C 10.619469 17.025875 10.683922 16.828891 10.669922 16.587891 C 10.607922 15.353891 10.603469 14.311266 10.605469 13.697266 L 13.412109 13.697266 C 13.397109 14.503266 13.378047 15.937062 13.373047 17.039062 C 12.958047 17.068062 12.8135 17.120094 12.6875 17.246094 C 12.5435 17.389094 12.504031 17.673328 12.582031 17.861328 C 12.707031 18.162328 14.288844 19.909063 14.839844 19.914062 L 14.84375 19.914062 C 15.38875 19.902062 16.954125 18.156422 17.078125 17.857422 C 17.158125 17.668422 17.116703 17.385188 16.970703 17.242188 C 16.856703 17.131187 16.751344 17.075063 16.277344 17.039062 C 16.273344 16.881063 16.269672 16.736125 16.263672 16.578125 C 16.232672 15.703125 16.184453 14.381109 16.314453 7.6621094 C 16.318453 7.4291094 16.253141 7.2424688 16.119141 7.1054688 C 16.029141 7.0134688 15.867516 6.9033438 15.603516 6.9023438 C 15.077516 6.9003438 14.548531 6.9002969 14.019531 6.9042969 C 13.762531 6.9082969 13.603625 7.0193281 13.515625 7.1113281 C 13.383625 7.2493281 13.319172 7.4360156 13.326172 7.6660156 C 13.379172 9.2780156 13.387719 10.439312 13.386719 11.070312 L 10.589844 11.070312 C 10.592844 10.822312 10.596609 10.548766 10.599609 10.259766 C 10.609609 9.1767656 10.620688 7.8580312 10.679688 6.9570312 C 11.105687 6.9230313 11.237516 6.8669531 11.353516 6.7519531 C 11.496516 6.6089531 11.537937 6.3305781 11.460938 6.1425781 C 11.327938 5.8195781 9.7085 4.0820312 9.1875 4.0820312 z M 9.1855469 5.1777344 C 9.4165469 5.3667344 9.7782656 5.7029531 10.072266 6.0019531 C 9.8602656 6.0599531 9.7050781 6.2534219 9.7050781 6.4824219 L 9.7070312 6.5839844 C 9.6250312 7.4629844 9.6096563 9.0099531 9.5976562 10.251953 C 9.5926562 10.755953 9.5880781 11.212547 9.5800781 11.560547 C 9.5770781 11.694547 9.6276562 11.824875 9.7226562 11.921875 C 9.8156562 12.017875 9.9450781 12.070312 10.080078 12.070312 L 13.882812 12.070312 C 14.158812 12.070312 14.382812 11.846312 14.382812 11.570312 L 14.382812 11.466797 C 14.385812 11.048797 14.393937 9.8132969 14.335938 7.9042969 C 14.660938 7.9022969 14.983594 7.9023438 15.308594 7.9023438 C 15.184594 14.425344 15.231672 15.741234 15.263672 16.615234 C 15.273672 16.903234 15.283203 17.144625 15.283203 17.515625 C 15.283203 17.760625 15.459359 17.965812 15.693359 18.007812 C 15.409359 18.301812 15.062891 18.630359 14.837891 18.818359 C 14.610891 18.630359 14.258703 18.301813 13.970703 18.007812 C 14.200703 17.962813 14.372094 17.758578 14.371094 17.517578 C 14.371094 16.290578 14.397063 14.311422 14.414062 13.482422 C 14.415062 13.407422 14.410531 13.343266 14.394531 13.197266 C 14.394531 12.921266 14.170531 12.697266 13.894531 12.697266 L 10.107422 12.697266 C 9.8314219 12.697266 9.6074219 12.921266 9.6074219 13.197266 L 9.6054688 13.369141 C 9.6024688 13.863141 9.5971562 14.983625 9.6601562 16.390625 L 8.6953125 16.388672 L 8.7011719 16.214844 C 8.7461719 14.604844 8.8186406 12.172813 8.6816406 6.6328125 L 8.6816406 6.4824219 C 8.6816406 6.2474219 8.5198281 6.0490937 8.2988281 5.9960938 C 8.5948281 5.6980937 8.9555469 5.3657344 9.1855469 5.1777344 z"/>
                      </svg>
                    </a>
                  {/if}
                </div>
              </div>

              <!-- Right - Profile Media (Image or Video) -->
              <div class="flex-shrink-0 w-full md:w-auto">
                {#if hero.media_type === 'video' && hero.video_url}
                  <div class="relative">
                    <div class="absolute -bottom-4 -right-4 w-24 h-24 sm:w-32 sm:h-32 bg-primary-500/30 rounded-full blur-3xl -z-10"></div>
                    <video 
                      src={getMediaUrl(hero.video_url)}
                      autoplay
                      loop
                      muted
                      playsinline
                      class="w-full aspect-video sm:w-[28rem] sm:h-[18.67rem] md:w-[36rem] md:h-96 lg:w-[42rem] lg:h-[28rem] rounded-lg sm:rounded-xl border-2 sm:border-4 border-zinc-900 object-cover shadow-2xl shadow-primary-500/20 hover:shadow-primary-500/40 transition-shadow duration-300 relative z-10"
                    >
                      <track kind="captions" />
                    </video>
                  </div>
                {:else if hero.image_url}
                  <div class="relative">
                    <div class="absolute -bottom-4 -right-4 w-24 h-24 sm:w-32 sm:h-32 bg-primary-500/30 rounded-full blur-3xl -z-10"></div>
                    <img 
                      src={getMediaUrl(hero.image_url)} 
                      alt={hero.name}
                      class="w-full aspect-video sm:w-[28rem] sm:h-[18.67rem] md:w-[36rem] md:h-96 lg:w-[42rem] lg:h-[28rem] rounded-lg sm:rounded-xl border-2 sm:border-4 border-zinc-900 object-cover shadow-2xl shadow-primary-500/20 hover:shadow-primary-500/40 transition-shadow duration-300 relative z-10"
                    />
                  </div>
                {/if}
              </div>
            </div>
          </div>
        </div>
      </section>
    {/if}

    <!-- Skills Section -->
    {#if skills.length > 0}
      <section id="skills" class="py-12 sm:py-16 md:py-20 bg-zinc-950/30">
        <div class="container mx-auto px-4 sm:px-6 lg:px-8">
          <h2 class="section-title text-center mb-12">Technical Arsenal</h2>

          <!-- Category Filter -->
          <div class="flex flex-wrap justify-center gap-2 mb-10">
            {#each categories as category}
              <button
                on:click={() => selectedCategory = category}
                class="px-4 py-1.5 text-sm font-medium transition-colors duration-200 {selectedCategory === category ? 'text-primary-500 border-b-2 border-primary-500' : 'text-gray-400 hover:text-gray-300'}"
              >
                {category}
              </button>
            {/each}
          </div>

          {#if skills.filter(s => selectedCategory === 'All' || s.category.toLowerCase() === selectedCategory.toLowerCase()).length > 0}
            {#if !showAllSkills && selectedCategory === 'All'}
              <!-- Scrolling Animation for Default "All" state -->
              <div class="max-w-full mx-auto overflow-hidden">
                <div class="flex animate-scroll-left">
                  <!-- First set of skills -->
                  {#each skills as skill}
                    <div class="flex-shrink-0 mx-2">
                      <div class="flex flex-col items-center justify-center p-4 bg-zinc-900/50 border border-zinc-800 rounded-lg hover:border-primary-500/50 transition-all hover:scale-105 w-32">
                        {#if skill.icon_image}
                          <img src={getMediaUrl(skill.icon_image)} alt={skill.name} class="w-12 h-12 mb-2 object-contain" />
                        {:else if skill.icon}
                          <span class="text-3xl mb-2">{skill.icon}</span>
                        {/if}
                        <h3 class="text-sm font-medium text-white text-center">{skill.name}</h3>
                      </div>
                    </div>
                  {/each}
                  <!-- Duplicate set for seamless loop -->
                  {#each skills as skill}
                    <div class="flex-shrink-0 mx-2">
                      <div class="flex flex-col items-center justify-center p-4 bg-zinc-900/50 border border-zinc-800 rounded-lg hover:border-primary-500/50 transition-all hover:scale-105 w-32">
                        {#if skill.icon_image}
                          <img src={getMediaUrl(skill.icon_image)} alt={skill.name} class="w-12 h-12 mb-2 object-contain" />
                        {:else if skill.icon}
                          <span class="text-3xl mb-2">{skill.icon}</span>
                        {/if}
                        <h3 class="text-sm font-medium text-white text-center">{skill.name}</h3>
                      </div>
                    </div>
                  {/each}
                </div>
              </div>
              
              <!-- View All Button for scrolling state -->
              <div class="flex justify-center mt-8">
                <button
                  on:click={() => showAllSkills = !showAllSkills}
                  class="px-6 py-2 bg-zinc-900 border border-zinc-800 text-gray-300 rounded-lg hover:bg-zinc-800 hover:border-primary-500 transition-all"
                >
                  View All
                </button>
              </div>
            {:else}
              <!-- Grid View (for "View All" clicked or other categories) -->
              <div class="max-w-5xl mx-auto">
                <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
                  {#each (showAllSkills ? skills.filter(s => selectedCategory === 'All' || s.category.toLowerCase() === selectedCategory.toLowerCase()) : skills.filter(s => selectedCategory === 'All' || s.category.toLowerCase() === selectedCategory.toLowerCase()).slice(0, 4)) as skill}
                    <div class="group">
                      <div class="flex flex-col items-center justify-center p-4 bg-zinc-900/50 border border-zinc-800 rounded-lg hover:border-primary-500/50 transition-all hover:scale-105">
                        {#if skill.icon_image}
                          <img src={getMediaUrl(skill.icon_image)} alt={skill.name} class="w-12 h-12 mb-2 object-contain" />
                        {:else if skill.icon}
                          <span class="text-3xl mb-2">{skill.icon}</span>
                        {/if}
                        <h3 class="text-sm font-medium text-white text-center">{skill.name}</h3>
                      </div>
                    </div>
                  {/each}
                </div>

                <!-- Show Less Button (only for "All" category when expanded) -->
                {#if selectedCategory === 'All' && showAllSkills}
                  <div class="flex justify-center mt-8">
                    <button
                      on:click={() => showAllSkills = !showAllSkills}
                      class="px-6 py-2 bg-zinc-900 border border-zinc-800 text-gray-300 rounded-lg hover:bg-zinc-800 hover:border-primary-500 transition-all"
                    >
                      Show Less
                    </button>
                  </div>
                {/if}
                
                <!-- View All Button for other categories -->
                {#if selectedCategory !== 'All' && skills.filter(s => s.category.toLowerCase() === selectedCategory.toLowerCase()).length > 4}
                  <div class="flex justify-center mt-8">
                    <button
                      on:click={() => showAllSkills = !showAllSkills}
                      class="px-6 py-2 bg-zinc-900 border border-zinc-800 text-gray-300 rounded-lg hover:bg-zinc-800 hover:border-primary-500 transition-all"
                    >
                      {showAllSkills ? 'Show Less' : 'View All'}
                    </button>
                  </div>
                {/if}
              </div>
            {/if}
          {:else}
            <p class="text-center text-gray-400">No skills available for this category.</p>
          {/if}
        </div>
      </section>
    {/if}

    <!-- Projects Section -->
    {#if projects.length > 0}
      <section id="projects" class="py-12 sm:py-16 md:py-24 bg-zinc-950">
        <div class="container mx-auto px-4 sm:px-6 lg:px-8 max-w-6xl">
          <h2 class="section-title text-center mb-12">Projects</h2>
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {#each projects as project}
              <div class="card group">
                {#if project.featured}
                  <span class="inline-block bg-primary-500 text-black text-xs px-2 py-1 rounded mb-2 font-semibold">Featured</span>
                {/if}
                <h3 class="text-xl font-semibold mb-2 text-white group-hover:text-primary-400 transition-colors">{project.title}</h3>
                <p class="text-gray-400 mb-4">{project.description}</p>
                <div class="flex flex-wrap gap-2 mb-4">
                  {#each project.technologies as tech}
                    <span class="bg-zinc-900 text-primary-400 text-xs px-2 py-1 rounded border border-zinc-800">{tech}</span>
                  {/each}
                </div>
                <div class="flex gap-4">
                  {#if project.demo_url}
                    <a href={project.demo_url} target="_blank" rel="noopener" class="text-primary-500 hover:text-primary-400 transition-colors">Demo →</a>
                  {/if}
                  {#if project.github_url}
                    <a href={project.github_url} target="_blank" rel="noopener" class="text-primary-500 hover:text-primary-400 transition-colors">GitHub →</a>
                  {/if}
                </div>
              </div>
            {/each}
          </div>
        </div>
      </section>
    {/if}

    <!-- Experience Section -->
    {#if experience.length > 0}
      <section id="experience" class="py-12 sm:py-16 md:py-24 bg-black">
        <div class="container mx-auto px-4 sm:px-6 lg:px-8 max-w-4xl">
          <h2 class="section-title text-center mb-12">Experience</h2>
          <div class="space-y-8">
            {#each experience as exp}
              <div class="border-l-4 border-primary-500 pl-6 py-4 hover:border-primary-400 transition-colors">
                <h3 class="text-2xl font-semibold text-white">{exp.position}</h3>
                <p class="text-lg text-gray-300 mb-2">{exp.company}</p>
                <p class="text-sm text-gray-500 mb-3">
                  {new Date(exp.start_date).toLocaleDateString()} - 
                  {exp.current ? 'Present' : (exp.end_date ? new Date(exp.end_date).toLocaleDateString() : 'N/A')}
                </p>
                <p class="text-gray-400 mb-3">{exp.description}</p>
                <div class="flex flex-wrap gap-2">
                  {#each exp.technologies as tech}
                    <span class="bg-zinc-900 text-primary-400 text-xs px-2 py-1 rounded border border-zinc-800">{tech}</span>
                  {/each}
                </div>
              </div>
            {/each}
          </div>
        </div>
      </section>
    {/if}

    <!-- Certifications Section -->
    {#if certifications.length > 0}
      <section id="certifications" class="py-12 sm:py-16 md:py-24 bg-zinc-950">
        <div class="container mx-auto px-4 sm:px-6 lg:px-8 max-w-6xl">
          <h2 class="section-title text-center mb-12">Accomplishments</h2>
          
          <!-- Category Tabs -->
          <div class="flex flex-wrap justify-center gap-3 mb-12">
            <button 
              on:click={() => { showAllAchievements = false; showAllCertificates = false; showAllParticipation = false; showAllCertifications = false; }}
              class="px-6 py-2.5 rounded-lg font-semibold transition-all {!showAllAchievements && !showAllCertificates && !showAllParticipation ? 'bg-primary-500 text-black' : 'bg-zinc-900 text-gray-400 hover:bg-zinc-800 hover:text-primary-400'}"
            >
              All
            </button>
            {#if certifications.filter(c => c.category === 'achievements').length > 0}
              <button 
                on:click={() => { showAllAchievements = true; showAllCertificates = false; showAllParticipation = false; showAllCertifications = false; }}
                class="px-6 py-2.5 rounded-lg font-semibold transition-all {showAllAchievements ? 'bg-yellow-500 text-black' : 'bg-zinc-900 text-gray-400 hover:bg-zinc-800 hover:text-yellow-400'}"
              >
                Achievements
              </button>
            {/if}
            {#if certifications.filter(c => c.category === 'certificate').length > 0}
              <button 
                on:click={() => { showAllAchievements = false; showAllCertificates = true; showAllParticipation = false; showAllCertifications = false; }}
                class="px-6 py-2.5 rounded-lg font-semibold transition-all {showAllCertificates ? 'bg-blue-500 text-black' : 'bg-zinc-900 text-gray-400 hover:bg-zinc-800 hover:text-blue-400'}"
              >
                Certificates
              </button>
            {/if}
            {#if certifications.filter(c => c.category === 'participation').length > 0}
              <button 
                on:click={() => { showAllAchievements = false; showAllCertificates = false; showAllParticipation = true; showAllCertifications = false; }}
                class="px-6 py-2.5 rounded-lg font-semibold transition-all {showAllParticipation ? 'bg-green-500 text-black' : 'bg-zinc-900 text-gray-400 hover:bg-zinc-800 hover:text-green-400'}"
              >
                Participation
              </button>
            {/if}
          </div>

          <!-- Certifications Grid -->
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {#each certifications.filter(c => {
              if (showAllAchievements) return c.category === 'achievements';
              if (showAllCertificates) return c.category === 'certificate';
              if (showAllParticipation) return c.category === 'participation';
              return true;
            }).slice(0, (showAllCertifications || showAllAchievements || showAllCertificates || showAllParticipation) ? certifications.length : 3) as cert}
              <div class="card group {cert.category === 'achievements' ? 'border-yellow-500/20 hover:border-yellow-500/50' : cert.category === 'certificate' ? 'border-blue-500/20 hover:border-blue-500/50' : 'border-green-500/20 hover:border-green-500/50'}">
                {#if cert.image_url}
                  <div class="mb-4 rounded-lg overflow-hidden border border-zinc-800 transition-colors {cert.category === 'achievements' ? 'group-hover:border-yellow-500/50' : cert.category === 'certificate' ? 'group-hover:border-blue-500/50' : 'group-hover:border-green-500/50'}">
                    <img 
                      src={getMediaUrl(cert.image_url)} 
                      alt={cert.name}
                      class="w-full h-48 object-cover"
                    />
                  </div>
                {/if}
                {#if cert.category === 'achievements'}
                  <span class="inline-block px-2 py-1 mb-3 rounded text-xs font-semibold uppercase bg-yellow-500/10 text-yellow-500 border border-yellow-500/30">
                    Achievement
                  </span>
                {:else if cert.category === 'certificate'}
                  <span class="inline-block px-2 py-1 mb-3 rounded text-xs font-semibold uppercase bg-blue-500/10 text-blue-500 border border-blue-500/30">
                    Certificate
                  </span>
                {:else if cert.category === 'participation'}
                  <span class="inline-block px-2 py-1 mb-3 rounded text-xs font-semibold uppercase bg-green-500/10 text-green-500 border border-green-500/30">
                    Participation
                  </span>
                {/if}
                <h3 class="text-xl font-semibold mb-2 text-white transition-colors {cert.category === 'achievements' ? 'group-hover:text-yellow-400' : cert.category === 'certificate' ? 'group-hover:text-blue-400' : 'group-hover:text-green-400'}">{cert.name}</h3>
                <p class="text-gray-300 mb-2">{cert.issuer}</p>
                <p class="text-sm text-gray-500 mb-3">
                  Issued: {new Date(cert.issue_date).toLocaleDateString()}
                </p>
                {#if cert.credential_url}
                  <a href={cert.credential_url} target="_blank" rel="noopener" class="text-sm font-medium transition-colors {cert.category === 'achievements' ? 'text-yellow-500 hover:text-yellow-400' : cert.category === 'certificate' ? 'text-blue-500 hover:text-blue-400' : 'text-green-500 hover:text-green-400'}">
                    View Credential →
                  </a>
                {/if}
              </div>
            {/each}
          </div>
          
          <!-- View All Button -->
          {#if certifications.length > 3 && !showAllAchievements && !showAllCertificates && !showAllParticipation}
            <div class="flex justify-center mt-8">
              <button 
                on:click={() => showAllCertifications = !showAllCertifications}
                class="px-8 py-3 bg-primary-500/10 border border-primary-500/30 text-primary-500 rounded-lg hover:bg-primary-500/20 hover:border-primary-500/50 transition-all font-semibold"
              >
                {showAllCertifications ? 'Show Less' : 'View All'}
              </button>
            </div>
          {/if}
        </div>
      </section>
    {/if}

    <!-- Blog Section -->
    {#if blogPosts.length > 0}
      <section class="py-16 md:py-24 bg-zinc-950">
        <div class="container mx-auto px-4 max-w-6xl">
          <h2 class="section-title text-center mb-12">Blog</h2>
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {#each blogPosts as post}
              <div class="card group cursor-pointer">
                <h3 class="text-xl font-semibold mb-2 text-white group-hover:text-primary-400 transition-colors">{post.title}</h3>
                <p class="text-gray-400 mb-4">{post.excerpt}</p>
                <div class="flex flex-wrap gap-2 mb-4">
                  {#each post.tags as tag}
                    <span class="bg-zinc-900 text-primary-400 text-xs px-2 py-1 rounded border border-zinc-800">{tag}</span>
                  {/each}
                </div>
                <p class="text-sm text-gray-500">
                  {post.created_at ? new Date(post.created_at).toLocaleDateString() : ''}
                </p>
              </div>
            {/each}
          </div>
        </div>
      </section>
    {/if}

    <!-- Contact Section -->
    {#if contact}
      <section id="contact" class="py-12 sm:py-16 md:py-24 bg-zinc-950">
        <div class="container mx-auto px-4 sm:px-6 lg:px-8 max-w-5xl">
          <h2 class="section-title text-center mb-12">Get In Touch</h2>
          
          <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 lg:gap-12">
            <!-- Contact Information -->
            <div class="space-y-6">
              <div>
                <h3 class="text-2xl font-bold text-white mb-6">Contact Information</h3>
                <p class="text-gray-400 mb-8">Feel free to reach out for collaborations or just a friendly chat.</p>
              </div>

              <div class="space-y-4">
                <div class="flex items-start gap-4 p-4 bg-zinc-900/50 border border-zinc-800 rounded-lg hover:border-primary-500/50 transition-colors">
                  <div class="p-2 bg-primary-500/10 rounded-lg">
                    <svg class="w-6 h-6 text-primary-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
                    </svg>
                  </div>
                  <div>
                    <h4 class="text-sm font-semibold text-primary-500 mb-1">Email</h4>
                    <a href="mailto:{contact.email}" class="break-all text-gray-300 hover:text-primary-400 transition-colors">{contact.email}</a>
                  </div>
                </div>

                {#if contact.phone}
                  <div class="flex items-start gap-4 p-4 bg-zinc-900/50 border border-zinc-800 rounded-lg hover:border-primary-500/50 transition-colors">
                    <div class="p-2 bg-primary-500/10 rounded-lg">
                      <svg class="w-6 h-6 text-primary-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"/>
                      </svg>
                    </div>
                    <div>
                      <h4 class="text-sm font-semibold text-primary-500 mb-1">Phone</h4>
                      <a href="tel:{contact.phone}" class="text-gray-300 hover:text-primary-400 transition-colors">{contact.phone}</a>
                    </div>
                  </div>
                {/if}

                {#if contact.location}
                  <div class="flex items-start gap-4 p-4 bg-zinc-900/50 border border-zinc-800 rounded-lg hover:border-primary-500/50 transition-colors">
                    <div class="p-2 bg-primary-500/10 rounded-lg">
                      <svg class="w-6 h-6 text-primary-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"/>
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"/>
                      </svg>
                    </div>
                    <div>
                      <h4 class="text-sm font-semibold text-primary-500 mb-1">Location</h4>
                      <span class="text-gray-300">{contact.location}</span>
                    </div>
                  </div>
                {/if}

                <div class="flex items-start gap-4 p-4 bg-zinc-900/50 border border-zinc-800 rounded-lg hover:border-primary-500/50 transition-colors">
                  <div class="p-2 bg-primary-500/10 rounded-lg">
                    <svg class="w-6 h-6 text-primary-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                  </div>
                  <div>
                    <h4 class="text-sm font-semibold text-primary-500 mb-1">Availability</h4>
                    <span class="text-gray-300">{contact.availability}</span>
                  </div>
                </div>
              </div>
            </div>

            <!-- Contact Form -->
            <div class="card">
              <h3 class="text-2xl font-bold text-white mb-6">Send a Message</h3>
              
              {#if formSuccess}
                <div class="mb-6 p-4 bg-primary-500/10 border border-primary-500/50 rounded-lg">
                  <p class="text-primary-400 font-medium">✓ Message sent successfully! I'll get back to you soon.</p>
                </div>
              {/if}

              {#if formError}
                <div class="mb-6 p-4 bg-red-500/10 border border-red-500/50 rounded-lg">
                  <p class="text-red-400">{formError}</p>
                </div>
              {/if}

              <form on:submit={handleContactSubmit} class="space-y-4">
                <div>
                  <label for="name" class="block text-sm font-medium text-gray-300 mb-2">Name *</label>
                  <input
                    type="text"
                    id="name"
                    bind:value={formData.name}
                    required
                    class="input-field"
                    placeholder="Your name"
                    disabled={formSubmitting}
                  />
                </div>

                <div>
                  <label for="email" class="block text-sm font-medium text-gray-300 mb-2">Email *</label>
                  <input
                    type="email"
                    id="email"
                    bind:value={formData.email}
                    required
                    class="input-field"
                    placeholder="your.email@example.com"
                    disabled={formSubmitting}
                  />
                </div>

                <div>
                  <label for="subject" class="block text-sm font-medium text-gray-300 mb-2">Subject *</label>
                  <input
                    type="text"
                    id="subject"
                    bind:value={formData.subject}
                    required
                    class="input-field"
                    placeholder="What's this about?"
                    disabled={formSubmitting}
                  />
                </div>

                <div>
                  <label for="message" class="block text-sm font-medium text-gray-300 mb-2">Message *</label>
                  <textarea
                    id="message"
                    bind:value={formData.message}
                    required
                    rows="5"
                    class="input-field resize-none"
                    placeholder="Your message here..."
                    disabled={formSubmitting}
                  ></textarea>
                </div>

                <button
                  type="submit"
                  disabled={formSubmitting}
                  class="w-full btn-primary disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2"
                >
                  {#if formSubmitting}
                    <svg class="animate-spin h-5 w-5" fill="none" viewBox="0 0 24 24">
                      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                      <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                    </svg>
                    Sending...
                  {:else}
                    <span>Send Message</span>
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8"/>
                    </svg>
                  {/if}
                </button>
              </form>
            </div>
          </div>
        </div>
      </section>
    {/if}
  {/if}
</div>
