sampler2D BumpSampler : register(s1);
sampler2D DiffuseSampler : register(s0);
float4 RainNormalControls : register(c201);
sampler2D RainNormalSampler : register(s2);
float4 WetDarken : register(c200);
float bumpiness : register(c198);
float4 gAdrenoFXVars : register(c68);
float4 gAmbientOcclusionEffect : register(c63);
float4 gStencil : register(c61);
float4 gWaterGlobals : register(c64);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float specularColorFactor : register(c197);
float specularFactor : register(c196);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
};

struct PS_OUT
{
	float4 color : COLOR;
	float4 color1 : COLOR1;
	float4 color2 : COLOR2;
	float4 color3 : COLOR3;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	float3 r3;
	r0.x = saturate(-1 + i.color.x);
	r0.y = saturate(gAmbientOcclusionEffect.z + gAmbientOcclusionEffect.z);
	r0.z = saturate(gWaterGlobals.y);
	r1 = tex2D(DiffuseSampler, i.texcoord.xy);
	r2.xyz = r1.xyz * WetDarken.xyz + -r1.xyz;
	r2.xyz = r0.zzz * r2.xyz + r1.xyz;
	r3 = r1.xyz * WetDarken.xyz;
	r0.z = saturate(gWaterGlobals.y + -i.color.y);
	r2.xyz = (-r0.zzz >= 0) ? r2.xyz : r3.xyz;
	r1.xyz = (-i.color.yyy >= 0) ? r1.xyz : r2.xyz;
	r0.w = r1.w * i.color.w;
	r0.w = r0.w * globalScalars.x;
	r1.w = dot(r1.xyz, float3(0.2125, 0.7154, 0.0721));
	r2.xyz = lerp(r1.www, r1.xyz, gAdrenoFXVars.xxx);
	r3 = lerp(r1.xyz, r2.xyz, r0.yyy);
	o.color.xyz = r0.xxx * globalScalars2.zzz + r3.xyz;
	r0.y = globalScalars2.y;
	r0.xy = r0.yy * RainNormalControls.zw;
	r0.xy = i.texcoord.xy * RainNormalControls.xy + r0.xy;
	r1 = tex2D(RainNormalSampler, r0.xy);
	r0.x = -r1.w + 1;
	r0.x = -r1.x + r0.x;
	r0.xy = (r0.xx >= 0) ? r1.wy : r1.xy;
	r0.xy = r0.xy * 2 + -1;
	r1.xy = r0.xy * WetDarken.ww;
	r0.x = dot(r1.xy, -r1.xy) + 1;
	r1.w = max(r0.x, 0);
	r0.x = rsqrt(r1.w);
	r1.z = 1 / r0.x;
	r2 = tex2D(BumpSampler, i.texcoord.xy);
	r0.x = -r2.w + 1;
	r0.x = -r2.x + r0.x;
	r0.xy = (r0.xx >= 0) ? r2.wy : r2.xy;
	r0.xy = r0.xy * 2 + -1;
	r2.xy = r0.xy * bumpiness.xx;
	r0.x = dot(r2.xy, -r2.xy) + 1;
	r1.w = max(r0.x, 0);
	r0.x = rsqrt(r1.w);
	r2.z = 1 / r0.x;
	r3 = lerp(r2.xyz, r1.xyz, r0.zzz);
	r1.xyz = r3.xyz + 1E-05;
	r3 = normalize(r1.xyz);
	r1.xyz = (-r0.zzz >= 0) ? r2.xyz : r3.xyz;
	r1.xyz = (-i.color.yyy >= 0) ? r2.xyz : r1.xyz;
	r2.xyz = r1.xxx * i.texcoord4.xyz;
	r1.xzw = r1.zzz * i.texcoord1.xyz + r2.xyz;
	r1.xyz = r1.yyy * i.texcoord5.xyz + r1.xzw;
	r1.xyz = r1.xyz + 1E-05;
	r2.xyz = normalize(r1.xyz);
	o.color1.xyz = r2.xyz * 0.5 + 0.5;
	r1.z = gWaterGlobals.z;
	r2.x = lerp(specularColorFactor.x, r1.z, r0.z);
	r1.xw = float2(1, 0);
	r0.y = max(r1.x, specularFactor.x);
	r2.y = lerp(r0.y, gWaterGlobals.w, r0.z);
	r0.x = specularColorFactor.x;
	r1.yz = (-r0.zz >= 0) ? r0.xy : r2.xy;
	r0.xy = (-i.color.yy >= 0) ? r0.xy : r1.yz;
	r0.y = saturate(r0.y * 0.0051020407);
	o.color2.x = r0.x;
	r0.x = rsqrt(r0.y);
	o.color2.y = 1 / r0.x;
	o.color.w = r0.w;
	o.color1.w = r0.w;
	o.color2.w = r0.w;
	o.color2.z = i.color.x;
	o.color3 = r1.wwwx * gStencil.x;

	return o;
}
